# Argo CD

## Why ArgoCD

- **Existing problems**:
    - I have a team of 6 memebers
    - I have my EKS Cluster
    - I have 4 replicas of the Pods running
    - I need to scale up my workload to 8 running Pods
        - I can by doing the "kubectl scale" command
    - This is the manual deployment
    - whatever is in my Git need to be the same in my K8s cluster

- **there is a multiple CI/CD tools in the market such as**:
    - Jenkins
    - Rancher
    - Gitlab
    - ...
- **Argo Cd is solving multiple problems such as**:
    - 

![alt text](./a03_Images/image-2.png)

## DevOps/Kubernetes Objects used here
- **Git**: Single source of truth.
- **EKS**: AWS Elastic K8s cluster
- **Pod**
- **Deployment**
- **Namespace**
- **YAML Syntax**
- **Git Basics**
- **Helm**

[Go to A01 Documentation](./b01/README.md)



