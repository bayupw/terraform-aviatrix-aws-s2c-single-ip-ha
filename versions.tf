terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "~> 2.24.0" # UserConnect-6.9
    }
  }
}