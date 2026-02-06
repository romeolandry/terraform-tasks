variable "environment" {
    default ="default"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_user" "my_tf_iam_user" {
    name = "${local.iam_user_extension}_${var.environment}"
}

locals {
    iam_user_extension = "my_iam_user"
}
