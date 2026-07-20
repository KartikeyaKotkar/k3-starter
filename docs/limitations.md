# Known Limitations

This repository is designed as a **starter template** to demonstrate infrastructure-as-code, configuration management, GitOps, and observability. It is highly educational but has distinct boundaries to remain simple and accessible.

Before adapting this code for a production environment, you should be aware of the following limitations:

## 1. Single-Node Architecture (No HA)
The Terraform code currently provisions a single EC2 instance. This means the k3s cluster lacks High Availability (HA) for both the control plane and worker nodes. If the single node goes down, the cluster is down.
* **Production Fix:** Update Terraform to provision an Auto Scaling Group or multiple instances, and configure k3s to run an HA control plane using an external datastore (like RDS) or embedded etcd across 3+ nodes.

## 2. No Managed TLS / cert-manager
Currently, the ingress routes use HTTP or self-signed certificates (e.g., ArgoCD defaults). `cert-manager` is not installed, meaning you do not get automatic Let's Encrypt certificates.
* **Production Fix:** Deploy `cert-manager` via ArgoCD, configure a `ClusterIssuer` with your DNS provider (e.g., AWS Route53), and update the Ingress manifests to request certificates automatically.

## 3. Local State (Terraform)
By default, the `backend.tf` is configured to use `local` state. This avoids the chicken-and-egg problem of needing a pre-existing S3 bucket before applying the starter repo, but it means Terraform state is not shared amongst a team, and state locking is absent.
* **Production Fix:** Uncomment the `s3` backend block in `terraform/backend.tf` and supply an existing S3 bucket and DynamoDB table.

## 4. Unauthenticated Endpoints (Grafana)
Grafana is currently exposed over HTTP via the Traefik ingress at `grafana.local`. While it requires basic auth (`admin`/`prom-operator`), it lacks robust Identity Provider (IdP) integration (like GitHub OAuth, OIDC, or SAML) and TLS termination.
* **Production Fix:** Combine the TLS fix above with an OAuth proxy or native Grafana SSO configuration.

## 5. No External Alert Receivers
The `kube-prometheus-stack` deploys Alertmanager, and alerts will fire internally (e.g., high CPU usage), but they are not currently routed anywhere.
* **Production Fix:** Provide Alertmanager configuration values in `kubernetes/argocd/observability.yaml` with a valid Slack Webhook, Email SMTP server, or PagerDuty integration key.

## 6. Embedded Database
The FastAPI sample app doesn't connect to a database. The k3s cluster itself uses the embedded sqlite (or etcd) datastore.
* **Production Fix:** If your application requires state, provision an RDS instance in `main.tf` and inject the connection string as a Kubernetes Secret (e.g., via External Secrets Operator).
