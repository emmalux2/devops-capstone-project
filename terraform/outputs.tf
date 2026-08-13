output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.devops_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.devops_instance.public_dns
}

output "subnet_id" {
  description = "Subnet ID where the EC2 instance is launched"
  value       = aws_instance.devops_instance.subnet_id
}
