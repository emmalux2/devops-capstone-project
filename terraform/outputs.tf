# Show the public IP of the EC2 instance
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

# Show the public DNS name of the EC2 instance
output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.app_server.public_dns
}

# Show the subnet ID used
output "subnet_id" {
  description = "Subnet ID where the EC2 instance is launched"
  value       = aws_subnet.public_subnet.id
}

# Show the security group ID used
output "security_group_id" {
  description = "Security Group ID attached to the EC2 instance"
  value       = aws_security_group.devops_sg.id
}
