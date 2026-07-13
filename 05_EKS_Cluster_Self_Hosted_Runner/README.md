# 🚀 EKS Cluster with ALB, Argo CD, Prometheus, and Grafana

This project provisions an Amazon EKS cluster on AWS using Terraform modules and prepares it for modern Kubernetes workloads, including:

- AWS Load Balancer Controller for Application Load Balancers
- Argo CD for GitOps-based deployments
- Prometheus and Grafana for cluster and application monitoring

## 📁 Project Structure

```text
05_EKS_Cluster_ALB_Installed/
├── README.md
├── enviroment/
│   └── devlopement/
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       └── variables.tf
└── modules/
    ├── eks/
    ├── internet_gateway/
    ├── routes/
    ├── security_groups/
    ├── subnets/
    └── vpc/
```

## ✅ Prerequisites

Make sure the following tools are installed and configured:

- Terraform
- AWS CLI
- kubectl
- Helm
- An AWS account with permissions for EKS, IAM, VPC, and ELB

Configure AWS credentials:

```bash
aws configure
```

## ⚙️ Provision the EKS Cluster

Change to the environment folder and deploy the infrastructure:

```bash
cd enviroment/devlopement
terraform init
terraform plan -lock=false
terraform apply -auto-approve -lock=false
```

After deployment, connect kubectl to the cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name mangesh-cluster
kubectl get nodes
```

## 🔧 Install AWS Load Balancer Controller

The AWS Load Balancer Controller creates ALBs and NLBs for Kubernetes services.

### 1. Add the Helm repository

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
```

### 2. Create the IAM policy and role for the controller

```bash
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json
```

Create the IAM policy and attach it to a role that your EKS cluster can assume. You can also use the AWS console or the AWS CLI.

### 3. Install the controller with Helm

```bash
export CLUSTER_NAME=mangesh-cluster
export AWS_REGION=us-east-1
export VPC_ID=$(aws eks describe-cluster --name "$CLUSTER_NAME" --query "cluster.resourcesVpcConfig.vpcId" --output text)

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME \
  --set region=$AWS_REGION \
  --set vpcId=$VPC_ID \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.14.0
```

### 4. Verify the installation

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

## 🚢 Install Argo CD

Argo CD provides GitOps-based deployment workflows.

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Expose the Argo CD server using a LoadBalancer:

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Get the external address:

```bash
kubectl get svc -n argocd argocd-server
```

Get the initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Login to Argo CD using:

- Username: admin
- Password: the value returned above

## 📈 Install Prometheus and Grafana

Prometheus and Grafana are installed together using the kube-prometheus-stack chart.

### 1. Add the Helm repositories

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

### 2. Create the monitoring namespace

```bash
kubectl create namespace monitoring
```

### 3. Install the stack

```bash
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring
```

### 4. Verify the installation

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

### 5. Access Grafana

You can access Grafana using port-forwarding:

```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

Then open:

```text
http://localhost:3000
```

Default login details:

- Username: admin
- Password: You can retrieve it with:

```bash
kubectl get secret -n monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d
```

## 🔐 Install External Secrets Operator

External Secrets Operator helps sync secrets from AWS Secrets Manager or other backends into Kubernetes secrets.

### 1. Add the Helm repository

```bash
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
```

### 2. Create a namespace

```bash
kubectl create namespace external-secrets
```

### 3. Install the operator

```bash
helm install external-secrets external-secrets/external-secrets \
  -n external-secrets
```

### 4. Verify the installation

```bash
kubectl get pods -n external-secrets
kubectl get deployment -n external-secrets external-secrets
```

## 🏃 Self-Hosted GitHub Actions Runner on EKS

You can run GitHub Actions self-hosted runners inside your EKS cluster so your CI jobs execute on Kubernetes instead of GitHub-hosted machines.

### What is required

Before you begin, you need:

- A GitHub repository where you want to use self-hosted runners
- A GitHub personal access token or GitHub App token with runner registration permissions
- A Kubernetes namespace in the EKS cluster
- The Actions Runner Controller installed in the cluster

### 1. Install Actions Runner Controller

Add the Helm repository and install the controller:

```bash
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo update

kubectl create namespace actions-runner-system
helm install actions-runner-controller actions-runner-controller/actions-runner-controller \
  --namespace actions-runner-system
```

### 2. Create the GitHub token secret

Create a Kubernetes secret containing your GitHub token:

```bash
kubectl create secret generic controller-manager \
  -n actions-runner-system \
  --from-literal=github_token=YOUR_GITHUB_TOKEN
```

### 3. Create a runner deployment

Use your runner manifest file, for example the one already created in the runner folder:

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: eks-github-runner
  namespace: actions-runner-system
spec:
  template:
    spec:
      repository: "MangeshGot/vortex"
      labels:
        - eks-runner
---
apiVersion: actions.summerwind.dev/v1alpha1
kind: HorizontalRunnerAutoscaler
metadata:
  name: eks-runner-scaler
  namespace: actions-runner-system
spec:
  scaleTargetRef:
    name: eks-github-runner
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: TotalNumberOfQueuedAndInProgressWorkflowRuns
      repositoryNames:
        - "MangeshGot/vortex"
```

Save it as runner-deployment.yaml and apply it:

```bash
kubectl apply -f runner-deployment.yaml
```

### 4. Verify the runner pod

```bash
kubectl get pods -n actions-runner-system
kubectl get runners -A
```

### 5. Register the runner in GitHub

Open your GitHub repository settings and go to:

- Settings → Actions → Runners

Then click "New self-hosted runner" and follow the registration steps if needed. The Kubernetes runner will connect automatically once the token and repository settings are correct.

### 6. Test the runner

Use your repository https://github.com/MangeshGot/vortex and add a workflow like this:

```yaml
name: Docker Image CI

on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

jobs:
  build:
    runs-on: eks-runner

    steps:
      - uses: actions/checkout@v4

      - name: Read version from package.json
        id: package-version
        uses: martinbeentjes/npm-get-version-action@main

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: .
          file: Dockerfile
          push: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/${{ secrets.DOCKER_IMAGE_NAME }}:${{ steps.package-version.outputs.current-version }}
            ${{ secrets.DOCKERHUB_USERNAME }}/${{ secrets.DOCKER_IMAGE_NAME }}:latest
```

## 🧪 Optional: Test the Setup

To verify that the ingress and load balancer components are working, deploy a sample application and expose it via a Kubernetes Service.

```bash
kubectl create deployment demo --image=nginx
kubectl expose deployment demo --port=80 --type=LoadBalancer
kubectl get svc demo
```

## ✅ Test All Installed Components and Verify Passwords

Use the following commands to confirm that all major components are installed and running correctly.

### 1. Verify the Kubernetes cluster and nodes

```bash
kubectl get nodes
kubectl get namespaces
```

### 2. Verify the AWS Load Balancer Controller

```bash
kubectl get pods -n kube-system
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get svc -n kube-system
```

### 3. Verify Argo CD

```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
```

Get the Argo CD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Access Argo CD UI:

```bash
kubectl get svc -n argocd argocd-server
```

Use:

- Username: admin
- Password: the value shown above

### 4. Verify Prometheus and Grafana

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

Get the Grafana admin password:

```bash
kubectl get secret -n monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d
```

Access Grafana locally:

```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

Then open:

```text
http://localhost:3000
```

Use:

- Username: admin
- Password: the value shown above

### 5. Verify External Secrets Operator

```bash
kubectl get pods -n external-secrets
kubectl get deployment -n external-secrets external-secrets
```

### 6. Verify ingress or sample service exposure

```bash
kubectl get svc
kubectl get ingress -A
```

If you deployed the sample app, check the external address:

```bash
kubectl get svc demo
```

## 🧹 Cleanup

To remove the created resources from AWS:

```bash
cd enviroment/devlopement
terraform destroy -auto-approve -lock=false
```

## 💡 Notes

- The cluster name used in this guide is mangesh-cluster.
- If your Terraform variables differ, update the cluster name, region, and other values accordingly.
- For production environments, consider using ingress annotations, TLS, and proper RBAC policies.
kubectl create namespace actions-runner-system

kubectl create secret generic controller-manager \
  -n actions-runner-system \
  --from-literal=github_token=ghp_YOUR_TOKEN_HERE
