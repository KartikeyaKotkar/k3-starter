# Kubernetes Manifests

This directory contains the Kubernetes deployment manifests for our applications.

## Deploying the Sample FastAPI App

1. Ensure you have built and pushed the Docker image as described in `app/README.md`.
2. Edit `kubernetes/sample-app/manifests.yaml` and replace the placeholder image (`your-dockerhub-username/fastapi-k3s:latest`) with your actual image.
3. Ensure your `KUBECONFIG` is set to point to the cluster:
   ```bash
   export KUBECONFIG=../kubeconfig
   ```
4. Apply the manifests manually:
   ```bash
   kubectl apply -f sample-app/manifests.yaml
   ```

## Verification

Once deployed, wait for the pod to become ready:
```bash
kubectl get pods -l app=fastapi-sample
```

Test the ingress routing using the public IP of your EC2 node:
```bash
curl -i http://<node-public-ip>/health
```
You should receive a `200 OK` response with `{"status": "ok", "message": "Hello from k3s!"}`.
