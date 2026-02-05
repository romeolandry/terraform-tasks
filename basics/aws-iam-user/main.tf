variable "iam_user_name_sufixe" {
    default = "my_tf"
}

variable "list_of_user_names" {
    # default = ["ranga","robert","landry"]
    default = ["romeo","ranga","robert","landry"]
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
    # count = length(var.list_of_user_names) ## get list indexe number
    # name = "${var.iam_user_name_sufixe}_iam_user_${count.index} ## using number as index
    # name = var.list_of_user_names[count.index] ## get names by index

    ## terraform should use name as key
    for_each = toset(var.list_of_user_names)
    name = each.value
}
