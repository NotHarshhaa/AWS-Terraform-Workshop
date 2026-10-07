terraform {
  required_version = ">= 1.0.0" # Ensures compatibility with Terraform 1.x+

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0" # Uses latest AWS provider
    }
  }
}
