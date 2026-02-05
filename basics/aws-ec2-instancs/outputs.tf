output "aws_security_group_complete_details" {
  value = aws_security_group.http_server_sg
}

output "aws_instance_http_server_complete_details" {
  value = aws_instance.http_server
}
