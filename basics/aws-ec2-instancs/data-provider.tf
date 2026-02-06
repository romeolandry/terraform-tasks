## data provider for subnets: data.aws_subnets.default_subnets

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

## data provider instance type: data.aws_ec2_instance_type.ec2_instance_type
data "aws_ec2_instance_type" "ec2_instance_type" {
  instance_type = "t4g.small"
}

## AMI Dataprovider: data.aws_ami.aws_linux_2_latest
data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    ## values = ["al2023-ami-2023.10.20260120.4-kernel-6.1-arm64"]
    values = ["al2023-ami-2023.10.20260120.4-kernel-6.1-arm64"]
  }

}
