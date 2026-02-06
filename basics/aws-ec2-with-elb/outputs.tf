output "aws_security_group_complete_details" {
  value = aws_security_group.http_server_sg
}

output "aws_instance_http_server_complete_details_public_dns" {
  value = aws_instance.http_servers
}

output "aws_default_vpc_default" {
  value = aws_default_vpc.default
}
