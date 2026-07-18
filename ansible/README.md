# Ansible for k3s-starter

This directory contains the Ansible configuration and playbooks to bootstrap k3s on the infrastructure provisioned by Terraform.

## What this does
The `bootstrap.yml` playbook will:
1. Connect to the nodes provisioned by Terraform (using the generated `inventory.ini`).
2. Install `curl` if not present.
3. Install k3s via the official install script (if not already installed).
4. Wait for the k3s service to start.
5. Download the resulting `k3s.yaml` to the root of the repository as `kubeconfig`.
6. Automatically rewrite the `kubeconfig` to point to the node's public IP instead of `127.0.0.1`.

## Usage
Once you have applied Terraform (`terraform apply`), an `inventory.ini` will be automatically generated in this directory.

To run the playbook:
```bash
cd ansible/
ansible-playbook bootstrap.yml
```

To verify the cluster works:
```bash
cd ..
export KUBECONFIG=$(pwd)/kubeconfig
kubectl get nodes
```
