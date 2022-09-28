variable "aws_account" {
  description = "AWS account name."
  type        = string
  default     = "aws-account"
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_name" {
  description = "AWS region."
  type        = string
  default     = "spoke-vpc"
}

variable "vpc_cidr" {
  description = "AWS VPC CIDR."
  type        = string
  default     = "10.1.0.0/24"
}

variable "gw_name" {
  description = "AWS gateway name."
  type        = string
  default     = "aws-gw-1"
}

variable "gw_size" {
  description = "AWS gateway size."
  type        = string
  default     = "t3.micro"
}

variable "onprem_name" {
  description = "On-prem name (VPC and tag)."
  type        = string
  default     = "csr-vpc"
}

variable "onprem_cidr" {
  description = "On-prem CIDR."
  type        = string
  default     = "192.168.1.0/24"
}

variable "key_name" {
  description = "EC2 key name."
  type        = string
  default     = "ec2_keypair"
}

variable "admin_password" {
  description = "CSR admin password."
  type        = string
  default     = "Aviatrix123#"
}

variable "pre_shared_key" {
  description = "Pre-shared key."
  type        = string
  default     = "Aviatrix123#"
}