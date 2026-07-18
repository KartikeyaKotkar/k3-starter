# ArgoCD & GitOps

This directory contains the configuration needed to transition your cluster to a GitOps model using ArgoCD.

## Installing ArgoCD

ArgoCD is installed using an Ansible playbook that utilizes your local `kubeconfig`.

1. From the `ansible/` directory, run the playbook:
   ```bash
   cd ../../ansible
   ansible-playbook deploy-argocd.yml
   ```

2. Wait for the playbook to complete. It will automatically wait for the ArgoCD pods to be ready.

## Accessing the ArgoCD UI

1. Retrieve the initial admin password:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
   ```
   *Note: The username is `admin`.*

2. Port-forward the ArgoCD server to your local machine:
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```

3. Open your browser and navigate to `https://localhost:8080`. (Accept the self-signed certificate warning).

## Deploying via GitOps

To deploy the sample FastAPI application via ArgoCD:

1. Apply the ArgoCD Application manifest:
   ```bash
   cd ../argocd
   kubectl apply -f fastapi-app.yaml
   ```
2. ArgoCD will now continuously monitor the `kubernetes/sample-app` directory in your Git repository.
3. Make a change (like increasing replicas in `kubernetes/sample-app/manifests.yaml`), commit it, and push to GitHub.
4. Watch ArgoCD automatically detect the change and sync it to the cluster—no more `kubectl apply` needed!
