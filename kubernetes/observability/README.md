# Observability (Prometheus + Grafana)

This directory defines the observability stack deployed via ArgoCD.

## What is deployed

We deploy the `kube-prometheus-stack` which includes:
- Prometheus (for scraping and storing metrics)
- Grafana (for visualization)
- Alertmanager (for routing alerts)
- Node Exporter & Kube-State-Metrics (for cluster-level metrics)

## How to access Grafana

Grafana is exposed via an Ingress at `grafana.local`.

1. Get the public IP of your EC2 node (`terraform output node_public_ips`).
2. Add the following line to your local machine's `/etc/hosts` file (replace `<IP>` with the actual IP):
   ```
   <IP> grafana.local
   ```
3. Navigate to `http://grafana.local` in your browser.
4. Log in with the default credentials:
   - **Username:** `admin`
   - **Password:** `prom-operator`

## Logging (Loki)

Loki and Promtail are deployed to automatically collect logs from all containers. Because Grafana is pre-configured with Loki as a data source, you can query logs immediately.

### Querying Logs in Grafana

1. Log in to Grafana and navigate to **Explore** (the compass icon in the sidebar).
2. Ensure the Data Source in the top left is set to **Loki**.
3. You can use **LogQL** to search and filter logs.

**Example: Get all logs from the FastAPI app**
```logql
{app="fastapi-sample"}
```

**Example: Find errors in the FastAPI app**
```logql
{app="fastapi-sample"} |= "error"
```

## What we are NOT alerting on yet

> [!WARNING]
> While Alertmanager is deployed and Prometheus is evaluating alerting rules (such as node CPU/Memory pressure), **we have not configured any external receivers (Slack, Email, PagerDuty)**.
> This means alerts are generated internally within the cluster but are not being sent anywhere. This is a known limitation of the current starter scope.
