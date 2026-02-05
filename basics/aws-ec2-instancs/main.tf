terraform {
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

# HTTP Server -> SG (Security groupe)
# SG -> 80 TCP, 22 TCP (ssh), CIRD["0.0.0.0/0"] ->allow incomming request from all server(Ip-Address)

resource "aws_security_group" "http_server_sg" {
  name        = "http_server_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = "vpc-0c4051638ff8890d8"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere (Note: For production, limit this to your IP!)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules: Allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Using "-1" as a string is the standard for "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http-server-sg"
  }
}

## Aws Ec2 Instanz
resource "aws_instance" "http_server" {
  ami                    = "ami-035f2391d0ece4c71" ## Operating system
  key_name               = "default-ec2"
  instance_type          = "t4g.small"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = "subnet-0ac7df6fd1109a98b"
}
