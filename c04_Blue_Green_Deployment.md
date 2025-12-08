# Argo Rollout using blue-green deployment

## Argo Rollout (Blue/Green)
- Deploys 3 replicas of guestbook-ui.
- Uses **Blue/Green strategy** with:
    - Active service → *current version*
    - Preview service → *new version before publishing*
- Manual promotion (*autoPromotionEnabled: false*)
    - I decide when the new version becomes live.
- **Kubernetes Services**
    - *guestbook-ui*: receives real production traffic.
    - *guestbook-ui-blue-green*: receives preview traffic.
- **Ingress**
    - Exposes the app externally through *NGINX*.
    - Always points to active service → *guestbook-ui*.

## Prequisite

1. Argocd installation, follow **c02_Argo_CD_Installation.md**
2. Argo Rollout installation, follow **c03_Argo_CD_Rollout_Installation.md.md**

## Blue green deployment

1. Install ingress controller

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/aws/deploy.yaml
```

2. Create a repositry name argo-rollout-guestbook-blue-green and clone it into local

```css
https://github.com/tchatua/argo-rollout-blue-green/tree/develop
```

3. Create a file name guestbook-rollout.yaml with **guestbook-rollout** folder with the below code

```yaml
# Argo Rollouts + Services + Ingress manifest.

# -------------------------------
# ARGO ROLLOUT (BLUE/GREEN)
# -------------------------------
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: guestbook-ui    # Name of the rollout
  namespace: default    # Namespace where it will run
spec:
  replicas: 3               # Number of pods to run
  revisionHistoryLimit: 2   # Keep only the last 2 versions for rollback
  selector:
    matchLabels:
      app: guestbook-ui     # Select pods with this label     
  template:
    metadata:
      labels:
        app: guestbook-ui   # Apply same label to pod template       
    spec:
      containers:
        - name: guestbook-ui
          image: udemykcloud534/guestbook:green # Container Image version currently deployed (green)
          imagePullPolicy: Always               # Always pull the latest version
          ports:
            - containerPort: 8080       # Container application port

          # Readiness probe to ensure pod is healthy before receiving traffic
          readinessProbe:
            httpGet:
              path: /               # Check root path
              port: 8080            # On port 8080
            initialDelaySeconds: 5  # Wait 5s before first check
            periodSeconds: 10       # Check every 10 seconds

  # ROLLOUT STRATEGY = BLUE-GREEN DEPLOYMENT
  strategy:
    blueGreen:
      activeService: guestbook-ui               # Live traffic goes here (BLUE or GREEN active)
      previewService: guestbook-ui-blue-green   # New version is served here before promotion
      autoPromotionEnabled: false               # Manual promotion required (safer)
      scaleDownDelaySeconds: 300                # Wait 5 minutes before scaling down old version
---
# -------------------------------
# ACTIVE SERVICE (LIVE TRAFFIC)
# -------------------------------
apiVersion: v1
kind: Service
metadata:
  name: guestbook-ui    # This is the active service
  namespace: default
spec:
  ports:
    - port: 80          # Expose service on port 80 internally
      targetPort: 8080  # Forward to pod port 8080
  selector:
    app: guestbook-ui   # Select pods based on label
---
# -------------------------------
# PREVIEW SERVICE (NEW VERSION)
# -------------------------------
apiVersion: v1
kind: Service
metadata:
  name: guestbook-ui-blue-green     # Preview traffic service
  namespace: default
spec:
  ports:
    - port: 80                      # Same internal port
      targetPort: 8080              # Same pod port
  selector:
    app: guestbook-ui               # Label selector is the same
---
# -------------------------------
# INGRESS (EXTERNAL ACCESS)
# -------------------------------
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: guestbook-ui-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx"    # Tell Kubernetes to use NGINX ingress controller
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - path: /                 # Route all traffic
            pathType: Prefix
            backend:
              service:
                name: guestbook-ui  # Ingress sends traffic to ACTIVE service     
                port:
                  number: 80
```

## create application

1. create a file named application.yaml and make sure to verify repoURL matches the repositry which I cloned above.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook-rollout
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/crazylearning-cr/argo-rollout-guestbook-blue-green.git
    path: guestbook-rollout
    targetRevision: HEAD
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated: {}
```

2. Apply the application.yaml
```sh
kubectl apply -f application.yaml
```

## Blue to green deployment

1. Edit the file guestbook-rollout.yaml, change image: udemykcloud534/guestbook:green to image: udemykcloud534/guestbook:blue. commit the changes

2. sync the application from UI

3. Access the blue deployment.
```sh
kubectl get ingress -A 
```
4. Perform Blue-Green Deployment. change service guestbook-ui to guestbook-ui-blue-green commit the changes
```sh
kubectl edit ingress guestbook-ui-ingress -n default 
```










