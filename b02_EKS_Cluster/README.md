

## Install Argo CD CLI on Linux

```sh
# Download the latest CLI
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

# Make it executable
chmod +x argocd

# Move to a directory in your PATH
sudo mv argocd /usr/local/bin/
```
## Install Argo CD CLI on Windows


## Application installation

```sh
# Retrieves the default Argo CD admin password from the Kubernetes secret.
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo

# Log in to Argo CD CLI
argocd login localhost:8080
Username: admin
Password: 

# Configure kubectl for my EKS cluster
aws eks --region us-east-2 update-kubeconfig --name argocd-cluster
kubectl config current-context

# Add the EKS cluster to Argo CD
argocd cluster add arn:aws:eks:us-east-2:088354478627:cluster/argocd-cluster
# Registers your EKS cluster with Argo CD.
# Argo CD now knows where to deploy applications (argocd-cluster).

# Create a sample Argo CD application
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git  --path guestbook --dest-server https://7CDA280831F968B36C52ED79B7DD7458.gr7.us-east-2.eks.amazonaws.com --dest-namespace default
# Or
argocd app create guestbook 
    --repo https://github.com/argoproj/argocd-example-apps.git  
    --path guestbook 
    --dest-server https://94A30CB36E71A94F4619941D4121F2B5.gr7.us-east-2.eks.amazonaws.com
    --dest-namespace default
# Creates an Argo CD app named guestbook from the GitHub repo.
# Deploys to the EKS cluster at the specified endpoint (dest-server) and namespace default.
```
- Deployment Manifest file
```yaml
apiVersion: apps/v1 # The Kubernetes API version for a Deployment.
kind: Deployment    # Defines the resource type
metadata:
  name: guestbook-ui # The name of the Deployment (guestbook-ui).
spec:
  replicas: 1               # Kubernetes will run 1 pod of this application
  revisionHistoryLimit: 3   # Keeps 3 previous versions of the Deployment for rollback.
  selector:
    matchLabels:            # Important: These labels must match the labels in the Pod template.
      app: guestbook-ui     # The Deployment selects pods that have the label app=guestbook-ui.
  template:                 # This is the Pod template used to create Pods.
    metadata:
      labels:
        app: guestbook-ui   # The Pods will have the label app=guestbook-ui.
    spec:
      containers:       
        - image: gcr.io/google-samples/gb-frontend:v5 # image → The Docker image used for the frontend.
          name: guestbook-ui # 
          ports:
            - containerPort: 80 # The container listens on port 80.
---
apiVersion: v1
kind: Service
metadata:
  name: guestbook-ui # Creates a Service named guestbook-ui
spec:
  ports:
  - port: 80        # Listens on port 80
    targetPort: 80
  selector:
    app: guestbook-ui   # Forwards traffic to pods labeled app=guestbook-ui
                        # Works with your Deployment, since your pods have the same label.
```
```sh
# Port-forward the application UI
kubectl port-forward svc/guestbook-ui -n default 8081:80
# Forwards the Guestbook service UI from the cluster to your local machine.
# Access it in the browser at http://localhost:8081

## Tips:

- Make sure the region in your aws eks update-kubeconfig command matches the region of your cluster.
- You can combine argocd login and argocd cluster add into a script for quick setup.
- Always verify the cluster context before deploying:
```sh
kubectl config current-context
argocd cluster list
```

# Scaling the deployment
```sh
kubectl scale deploy guestbook-ui --replicas=1 -n default
```





