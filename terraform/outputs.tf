output "server_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "Public IP address of the deployed EC2 server"
}
