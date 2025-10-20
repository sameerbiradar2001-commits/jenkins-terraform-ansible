output "public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "ssh_user" {
  value = var.ssh_user
}

output "instance_id" {
  value       = aws_instance.jenkins.id
  description = "ID of the Jenkins EC2 instance"
}

output "private_key_path" {
  value = replace(var.public_key_path, ".pub", "")
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}
