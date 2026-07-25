terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["/home/mangesh/.aws/config"]
  shared_credentials_files = ["/home/mangesh/.aws/credentials"]
  profile                  = "default"
}
