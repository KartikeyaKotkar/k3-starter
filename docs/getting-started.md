# Getting Started with k3s-starter

This guide will take you from a fresh clone of this repository to a fully functional, observable k3s cluster running on AWS.

## Prerequisites

- **AWS Account:** You need active credentials (e.g., `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).
- **Terraform** (v1.0.0+)
- **Ansible** (v2.10+)
- **kubectl**
- **Docker** (to build your application images)

---

## Step 1: Provision Infrastructure (Terraform)

We use Terraform to spin up the VPC, networking, Security Groups, and an EC2 instance on AWS.

1. Navigate to the Terraform directory:
   ```bash
   cd terraform
   ```
2. Initialize and apply:
   ```bash
   terraform init
   terraform apply
   ```
   *Note: Terraform will automatically generate an `inventory.ini` file for Ansible upon successful completion.*

## Step 2: Bootstrap the Cluster (Ansible)

We use Ansible to connect to the new EC2 instance, install k3s, and retrieve the Kubernetes credentials.

1. Navigate to the Ansible directory:
   ```bash
   cd ../ansible
   ```
2. Run the bootstrap playbook:
   ```bash
   ansible-playbook bootstrap.yml
   ```
3. Verify connection:
   ```bash
   cd ..
   export KUBECONFIG=$(pwd)/kubeconfig
   kubectl get nodes
   ```
   You should see your single k3s node in the `Ready` state.

## Step 3: Establish GitOps (ArgoCD)

To transition from manual deployments to declarative GitOps, install ArgoCD.

1. Run the deployment playbook:
   ```bash
   cd ansible
   ansible-playbook deploy-argocd.yml
   ```
2. Deploy the core applications by pushing your changes to GitHub, then applying the ArgoCD Application definitions:
   ```bash
   cd ../kubernetes/argocd
   kubectl apply -f fastapi-app.yaml
   kubectl apply -f observability.yaml
   kubectl apply -f loki.yaml
   ```

## Step 4: Verify Applications and Observability

1. **FastAPI Application:**
   Your FastAPI sample app is now running. Test its health endpoint using the public IP of your EC2 instance:
   ```bash
   curl -i http://<node-public-ip>/health
   ```

2. **Grafana & Prometheus:**
   Add `grafana.local` mapped to your EC2 public IP in your local `/etc/hosts` file.
   Navigate to `http://grafana.local` and log in with `admin` / `prom-operator`. You will see dashboards for both the cluster nodes and the FastAPI sample app.

3. **Loki Logging:**
   Inside Grafana, go to the **Explore** tab, select **Loki**, and query your logs (e.g., `{app="fastapi-sample"}`).

---

## Teardown

To avoid incurring AWS charges, destroy the cluster when you are done:

```bash
cd terraform
terraform destroy
```
