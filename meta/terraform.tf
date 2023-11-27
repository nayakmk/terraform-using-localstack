# Terraform Block
terraform {
  # This requires the Terraform CLI installed on the local system i.e. 1.4.6
  required_version = "~> 1.4.0"
  # required_version = "= 1.4.6"
  # required_version = "~> 1.3"
  # required_version = ">= 1.4.6"
  # required_version = "> 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.26.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}
