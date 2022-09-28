# Create AWS Spoke VPC
resource "aviatrix_vpc" "this" {
  cloud_type           = 1
  account_name         = var.aws_account
  region               = var.aws_region
  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}

# Create an Aviatrix Standalone Gateway with HA in AWS
resource "aviatrix_gateway" "this" {
  cloud_type   = 1
  account_name = var.aws_account
  gw_name      = var.gw_name
  vpc_id       = aviatrix_vpc.this.vpc_id
  vpc_reg      = aviatrix_vpc.this.region
  single_az_ha = false

  gw_size            = var.gw_size
  subnet             = aviatrix_vpc.this.public_subnets[0].cidr
  peering_ha_gw_size = var.gw_size
  peering_ha_subnet  = aviatrix_vpc.this.public_subnets[1].cidr
}

# Create a VPC to simulate on-prem
module "csr_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = var.onprem_name
  cidr                 = var.onprem_cidr
  azs                  = ["${var.aws_region}a"]
  public_subnets       = [cidrsubnet(var.onprem_cidr, 1, 0)]
  private_subnets      = [cidrsubnet(var.onprem_cidr, 1, 1)]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.onprem_name
  }
}

# Create CSR in on-prem VPC
module "csr1k" {
  source  = "bayupw/csr1k/aws"
  version = "1.0.0"

  vpc_id         = module.csr_vpc.vpc_id
  gi1_subnet_id  = module.csr_vpc.public_subnets[0]
  gi2_subnet_id  = module.csr_vpc.private_subnets[0]
  key_name       = var.key_name
  admin_password = var.admin_password
}

# Create an Aviatrix Site2cloud Connection
resource "aviatrix_site2cloud" "this" {
  vpc_id                     = aviatrix_vpc.this.vpc_id
  connection_name            = "s2c-to-csr"
  connection_type            = "unmapped"
  remote_gateway_type        = "generic"
  tunnel_type                = "policy"
  primary_cloud_gateway_name = aviatrix_gateway.this.gw_name
  remote_gateway_ip          = module.csr1k.csr_instance.public_ip
  remote_subnet_cidr         = var.onprem_cidr
  local_subnet_cidr          = var.vpc_cidr
  ha_enabled                 = true
  enable_single_ip_ha        = true
  backup_gateway_name        = aviatrix_gateway.this.peering_ha_gw_name
  pre_shared_key             = var.pre_shared_key
}