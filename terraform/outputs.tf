output "node_public_ips" {
  description = "Public IP addresses of the k3s nodes"
  value       = aws_instance.k3s_node[*].public_ip
}

output "ssh_command" {
  description = "Command to SSH into the first node"
  value       = length(aws_instance.k3s_node) > 0 ? (var.ssh_key_name == "" ? "ssh -i ${path.module}/k3s-starter-key.pem ubuntu@${aws_instance.k3s_node[0].public_ip}" : "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.k3s_node[0].public_ip}") : ""
}
