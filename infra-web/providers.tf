terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# main region (S3, Route53 lookups)
provider "aws" {
  region = var.region
}

# us-east-1 is REQUIRED for CloudFront certificates
provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}
