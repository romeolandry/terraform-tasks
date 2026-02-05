terraform {
    required_providers {
        aws = {
            source ="hashicorp/aws"
            version ="~> 6.31.0"
        }
    }

}

provider "aws" {
    region ="us-east-1"
}

resource "aws_s3_bucket" "terraform_name_s3_bucket" {
    bucket = "my-s3-bucket-tf-udemy"
}
