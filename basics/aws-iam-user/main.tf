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

resource "aws_iam_user" "my_tf_iam_user" {
    name = "my_tf_iam_user"
}
