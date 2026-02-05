variable "users" {
    # default = ["ranga","robert","landry"]
    # default = ["romeo","ranga","robert","landry"]
    default = {
        Ranga:{country:"Cameroon"},
        James:{country:"US"},
        Tom:{country:"Germany"},
    }

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
    for_each = (var.users)
    name = each.key
    tags = {
      country: each.value.country
    }

}
