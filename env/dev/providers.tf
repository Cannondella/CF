provider "aws" {
  region  = "us-east-1"
  profile = "dev"

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
}
