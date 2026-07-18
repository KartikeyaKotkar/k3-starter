# Terraform for k3s-starter

This directory contains the Terraform configuration to provision the foundational infrastructure for the k3s cluster on AWS.

## What this provisions

Running `terraform apply` will create:
- A VPC with a public subnet, internet gateway, and route table.
- A Security Group allowing SSH (22), Kubernetes API (6443), and HTTP/HTTPS (80/443).
- EC2 instance(s) running Ubuntu 24.04 LTS to serve as the k3s node(s).
- An SSH key pair if one is not provided.

## What this does NOT do (and why)

- **DNS Management (Route53):** We are not provisioning DNS records. Since this is a starter template, we assume you might use an ephemeral IP or configure DNS externally using an existing domain.
- **TLS Certificates (ACM/Let's Encrypt):** TLS certificates are not provisioned at the infrastructure layer. They will be handled inside the cluster (e.g., via cert-manager or Traefik default certs) during the GitOps phase.
- **Managed Database (RDS):** k3s will use its embedded sqlite/etcd datastore to keep this starter lightweight.
- **Load Balancer (ALB/NLB):** We expose the node's public IP directly for simplicity. A production setup might place an NLB in front of the nodes.
- **Remote State Backend (S3/DynamoDB):** By default, this uses local state. A remote backend requires existing AWS resources (the bucket and table), which introduces a chicken-and-egg problem for a starter repository. Comments in `backend.tf` show how to enable it for production use.

## Usage

1. **Configure AWS Credentials:** Ensure you have your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` exported in your environment.
2. **Set Variables (Optional):** You can override default variables in a `terraform.tfvars` file (e.g., `aws_region`, `instance_type`, `node_count`).
3. **Run Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Clean Up

To tear down all resources with no orphaned infrastructure:
```bash
terraform destroy
```
