# Create EKS Cluster

## EKS Architecture

![alt text](../a01_Images/image.png)

- **Initialize Terraform**
```sh
cd b02_EKS_Cluster/
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
