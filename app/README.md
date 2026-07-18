# Sample FastAPI Application

This is a minimal FastAPI application designed to verify that our k3s cluster, including its bundled Traefik ingress controller, is functioning correctly.

## Building and Publishing

Before you can deploy this to your cluster, you need to build the Docker image and push it to a container registry (like Docker Hub or GitHub Container Registry) that your cluster can access.

1. **Build the image**
   Replace `your-dockerhub-username` with your actual username.
   ```bash
   cd app/
   docker build -t your-dockerhub-username/fastapi-k3s:latest .
   ```

2. **Push the image**
   ```bash
   docker push your-dockerhub-username/fastapi-k3s:latest
   ```

Once pushed, remember to update `kubernetes/sample-app/manifests.yaml` with your actual image name before applying the manifests.
