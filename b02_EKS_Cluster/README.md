# b02_EKS_Cluster

## EKS Architecture

![alt text](../a01_Images/image.png)

- **Initialize Terraform**
```sh
terraform init
```

- **Format configurations files**
```sh
terraform fmt
```
- **Validate configurations files**
```sh
terraform validate
```

- **Plan the changes**
```sh
terraform plan
```

- **Apply the changes**
```sh
terraform appy --auto-approve
```

- **verify if EKS cluster is created**
```sh
aws eks update-kubeconfig --region us-east-2 --name argocd-cluster
kubectl get nodes -A
```

## Argo CD Installation

- create namespace for argocd
```sh
kubectl create namespace argocd
```

- Install argocd
```sh
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

$ kubectl get pods -n argocd
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          3m8s
argocd-applicationset-controller-5c9b95498b-cwhsv   1/1     Running   0          3m9s
argocd-dex-server-cccc8f49d-kkpsg                   1/1     Running   0          3m9s
argocd-notifications-controller-576c4d5559-4sjl8    1/1     Running   0          3m9s
argocd-redis-684497594f-rwkkb                       1/1     Running   0          3m9s
argocd-repo-server-6c857c79ff-6wljz                 1/1     Running   0          3m8s
argocd-server-9dc66fd74-v6m5x 


# My Argo CD installation worked perfectly
## all components, CRDs, deployments, services, roles, and network policies were created successfully
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/applicationsets.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/appprojects.argoproj.io created
serviceaccount/argocd-application-controller created
serviceaccount/argocd-applicationset-controller created
serviceaccount/argocd-dex-server created
serviceaccount/argocd-notifications-controller created
serviceaccount/argocd-redis created
serviceaccount/argocd-repo-server created
serviceaccount/argocd-server created
role.rbac.authorization.k8s.io/argocd-application-controller created
role.rbac.authorization.k8s.io/argocd-applicationset-controller created
role.rbac.authorization.k8s.io/argocd-dex-server created
role.rbac.authorization.k8s.io/argocd-notifications-controller created
role.rbac.authorization.k8s.io/argocd-redis created
role.rbac.authorization.k8s.io/argocd-server created
clusterrole.rbac.authorization.k8s.io/argocd-application-controller created
clusterrole.rbac.authorization.k8s.io/argocd-applicationset-controller created
clusterrole.rbac.authorization.k8s.io/argocd-server created
rolebinding.rbac.authorization.k8s.io/argocd-application-controller created
rolebinding.rbac.authorization.k8s.io/argocd-applicationset-controller created
rolebinding.rbac.authorization.k8s.io/argocd-dex-server created
rolebinding.rbac.authorization.k8s.io/argocd-notifications-controller created
rolebinding.rbac.authorization.k8s.io/argocd-redis created
rolebinding.rbac.authorization.k8s.io/argocd-server created
clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller created
clusterrolebinding.rbac.authorization.k8s.io/argocd-applicationset-controller created
clusterrolebinding.rbac.authorization.k8s.io/argocd-server created
configmap/argocd-cm created
configmap/argocd-cmd-params-cm created
configmap/argocd-gpg-keys-cm created
configmap/argocd-notifications-cm created
configmap/argocd-rbac-cm created
configmap/argocd-ssh-known-hosts-cm created
configmap/argocd-tls-certs-cm created
secret/argocd-notifications-secret created
secret/argocd-secret created
service/argocd-applicationset-controller created
service/argocd-dex-server created
service/argocd-metrics created
service/argocd-notifications-controller-metrics created
service/argocd-redis created
service/argocd-repo-server created
service/argocd-server created
service/argocd-server-metrics created
deployment.apps/argocd-applicationset-controller created
deployment.apps/argocd-dex-server created
deployment.apps/argocd-notifications-controller created
deployment.apps/argocd-redis created
deployment.apps/argocd-repo-server created
deployment.apps/argocd-server created
statefulset.apps/argocd-application-controller created
networkpolicy.networking.k8s.io/argocd-application-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-applicationset-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-dex-server-network-policy created
networkpolicy.networking.k8s.io/argocd-notifications-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-redis-network-policy created
networkpolicy.networking.k8s.io/argocd-repo-server-network-policy created
networkpolicy.networking.k8s.io/argocd-server-network-policy created

```

- forward port to access argo ui
```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

- access the default password to log in to argocd ui
    - Retrieves the default Argo CD admin password from the Kubernetes secret.
    - **base64 -d** decodes it because Kubernetes stores secrets in base64.
    - **echo** adds a newline after the password.
```sh
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo
```

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
- 

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
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git  --path guestbook --dest-server https://AEF04EC1B6D3BD66F50B414C2F5BE526.gr7.us-east-2.eks.amazonaws.com --dest-namespace default
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

# Argo Rollout
```css
Argo rollout is a Kubernetes controller and set of Custom Resource Definitions (CRD) that enable advanced deploynent strategies like Canary and Blue-Green. 
Unlike standard K8s deployments, which use a RollingUpdate strategy, Argo rollouts provide fine-gained control over traffic shifting and automated rollback based on metrics analysis.
In a Canary deployment, a new version of the application is gradually rolled out to a subnet of users, allowing me to monitor its performance before fully promoting it.
```


