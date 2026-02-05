variable "iam_user_name_sufixe" {
    default = "my_tf"
}

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
    count = 3
    name = "${var.iam_user_name_sufixe}_iam_user_${count.index}"
}
