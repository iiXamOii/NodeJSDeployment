terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }

  backend "s3" {
    bucket  = "nodejs-dev-terraform-state"
    key     = "tfstate/"
    region  = "us-east-1"
    encrypt = true
    profile = "terraform"
  }
}
provider "aws" {
  region = "us-east-1"
}

#terraform init -backend-config="key=tfstate/dev-vpc.terraform.tfstate" -reconfigure

