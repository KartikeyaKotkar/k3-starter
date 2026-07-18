resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    k3s_nodes = aws_instance.k3s_node[*].public_ip
    ssh_key   = var.ssh_key_name == "" ? "${path.module}/k3s-starter-key.pem" : "~/.ssh/id_rsa"
  })
  filename        = "${path.module}/../ansible/inventory.ini"
  file_permission = "0644"
}
