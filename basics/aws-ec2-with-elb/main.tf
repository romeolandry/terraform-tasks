terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}

# HTTP Server -> SG (Security groupe)
# SG -> 80 TCP, 22 TCP (ssh), CIRD["0.0.0.0/0"] ->allow incomming request from all server(Ip-Address)

# *** get default vpc from aws: terraform don't create or destroy it.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "http_server_sg" {
  name        = "http_server_sg"
  description = "Allow HTTP and SSH traffic"
  # vpc_id      = "vpc-0c4051638ff8890d8"
  vpc_id = aws_default_vpc.default.id ## use id from resource

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
resource "aws_instance" "http_servers" {

  ## Create one ec2 intance for each subnet
  for_each = toset(data.aws_subnets.default_subnets.ids)

  ami                    = data.aws_ami.aws_linux_2_latest.id # data provider data.aws_ami.aws_linux_2_latest
  key_name               = var.instance_key_name              # "default-ec2"
  instance_type          = data.aws_ec2_instance_type.ec2_instance_type.id
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = each.value

  tags = {
    name : "http_servers_${each.value}"
  }

  # Ensure the instance gets a public IP to allow SSH/HTTP access
  associate_public_ip_address = true

  ## Add html file using ssh connection
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair) # Fixed: Reads the file content
  }

  provisioner "remote-exec" {
    inline = [
      // install httpd
      "sudo yum install httpd -y",
      // start http server
      "sudo service httpd start",
      // copy file
      "echo Welcom to my Ec2 server - virtual server it at ${self.public_ip} | sudo tee /var/www/html/index.html"
    ]
  }

}

## loadbalancer SG
resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Lodbalancer Security group"
  vpc_id      = aws_default_vpc.default.id ## use id from resource

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "http-elb-sg"
  }
}

resource "aws_elb" "elb" {

  name            = "elb"
  subnets         = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances       = values(aws_instance.http_servers).*.id
  listener {

    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
