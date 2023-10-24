# add aws provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}
provider "aws" {
  # access_key = ""
  #secret_key = ""
  region                   = var.aws_region
  shared_credentials_files = ["c:\\users\\rahul\\.aws\\credentials"]
}
