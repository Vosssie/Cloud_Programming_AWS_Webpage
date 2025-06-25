terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
  }
  #backend "s3" { NO IDEA WHAT IT DOES AND NO RESOURCES
  #  bucket         = "your-terraform-state-bucket"
  #  key            = "website/terraform.tfstate"
  #  region         = "us-east-1"
  #  encrypt        = true
  #  dynamodb_table = "terraform-lock-table"
  #}
}

provider "aws" {
  region = var.region
}
