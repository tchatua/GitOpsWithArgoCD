# Install Argo Rollouts

1. create namespace for argo- rollouts

```sh
kubectl create namespace argo-rollouts
```

2. install argo rollouts
```sh
# To install Argo Rollouts into the argo-rollouts namespace
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

# Optional: Expose Argo Rollouts Dashboard. To open the UI:
kubectl port-forward -n argo-rollouts deployment/argo-rollouts-dashboard 3100:3100

# Then open your browser:
http://localhost:3100
```

3. Install Argo rollouts kubectl plugins

```sh
# Download the latest version of the kubectl-argo-rollouts binary for Linux (amd64 architecture)
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64

# Move the downloaded binary to /usr/local/bin so it can be executed system-wide
sudo mv kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts

# Make the file executable so I can run the kubectl-argo-rollouts command
sudo chmod +x /usr/local/bin/kubectl-argo-rollouts

# Verify installation
kubectl-argo-rollouts version
```
