terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }

  backend "s3" {
    bucket  = "dinoleung-com-tofu-state"
    key     = "dinoleung.com/opentofu.tfstate"
    region  = "ap-southeast-2"
    encrypt = true
  }
}
