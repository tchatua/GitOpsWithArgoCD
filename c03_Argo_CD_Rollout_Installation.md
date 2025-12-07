# Argo Rollout

```css
Argo rollout is a Kubernetes controller and set of Custom Resource Definitions (CRD) that enable advanced deploynent strategies like Canary and Blue-Green. 
Unlike standard K8s deployments, which use a RollingUpdate strategy, Argo rollouts provide fine-gained control over traffic shifting and automated rollback based on metrics analysis.
In a Canary deployment, a new version of the application is gradually rolled out to a subnet of users, allowing me to monitor its performance before fully promoting it.
```

## Install Argo Rollout

1. create namespace for argo- rollouts
```sh
kubectl create namespace argo-rollouts
```

2. install argo rollouts
```sh
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```

3. Install Argo rollouts CLI kubectl plugins
```sh
# only for Linux
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
sudo mv kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
sudo chmod +x /usr/local/bin/kubectl-argo-rollouts
```





