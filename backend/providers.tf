terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    archive = { source = "hashicorp/archive", version = "~> 2.4" }
  }
}

provider "aws" {
  region = var.region
}

# Only needed if you also manage ACM/CloudFront here. Safe to keep.
provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}
