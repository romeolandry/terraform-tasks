variable "iam_user_name_sufixe" {
  default = "my_tf"
}

variable "list_of_user_names" {
  # default = ["ranga","robert","landry"]
  default = ["romeo", "ranga", "robert", "landry"]
}

terraform {

  backend "s3" {
    bucket         = "kcrl-two-test-my-unique-terraform-state-2026"
    key            = "aws-iam-user"
    region         = "eu-central-1"
    dynamodb_table = "my_backend_state_bucket_table_lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31.0"
    }
  }

}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_user" "my_tf_iam_user" {
  for_each = toset(var.list_of_user_names)

  # This combines your prefix with the name from the list
  name = "${var.iam_user_name_sufixe}_${each.value}"
}
