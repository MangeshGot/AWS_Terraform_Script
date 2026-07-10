# 🚀 EKS, Jenkins, Argo CD, and Full CI/CD Deployment

This repository provisions the AWS infrastructure required to host a production-style Kubernetes environment on Amazon EKS. It is designed to support a complete DevOps workflow for the Vortex application, where Jenkins automates the build and deployment process and Argo CD helps manage application delivery to the cluster.

The application source code is maintained in the Vortex repository:
- https://github.com/MangeshGot/vortex.git

The deployment chart is maintained in the Helm chart repository:
- https://github.com/MangeshGot/helm-microservice.git

The CI/CD pipeline definition is available in the Jenkinsfile of the Vortex repository:
- https://github.com/MangeshGot/vortex/blob/main/Jenkinsfile

## 📁 Project Structure

```text
04_EKS_Jenkins_ArgoCd/
├── README.md
├── jenkins-values.yaml
├── enviroment/
│   ├── devlopement/
│   ├── production/
│   └── staging/
└── modules/
    ├── eks/
    ├── instance/
    ├── internet_gateway/
    ├── routes/
    ├── security_groups/
    ├── subnets/
    └── vpc/
```

## 🛠️ What This Project Creates

This project sets up the core infrastructure needed for a modern CI/CD platform:

- A dedicated VPC with public and private subnets
- Internet Gateway and routing for external access
- An Amazon EKS cluster with worker nodes
- Security groups for Jenkins and application access
- An EC2 instance for hosting Jenkins
- A Kubernetes-friendly environment for deploying the Vortex application using Helm

## 📋 Prerequisites

Before you begin, make sure the following tools are installed and configured:

- Terraform CLI
- AWS CLI
- kubectl
- Helm
- Docker
- An AWS account with permissions to create VPC, EKS, EC2, IAM, and related resources

## ⚙️ Configure Terraform Variables

Update the values in:

- enviroment/devlopement/terraform.tfvars

Example configuration:

```hcl
eks_vpc_region       = "us-east-1"
eks_access_key       = "YOUR_AWS_ACCESS_KEY"
eks_secret_key       = "YOUR_AWS_SECRET_KEY"
eks_vpc_cidr_block   = "192.168.0.0/24"
eks_public_subnet_1  = "192.168.0.0/26"
eks_public_subnet_2  = "192.168.0.64/26"
eks_private_subnet_1 = "192.168.0.128/26"
eks_private_subnet_2 = "192.168.0.192/26"
az_1a                = "us-east-1a"
az_1b                = "us-east-1b"
az_1c                = "us-east-1c"
az_1d                = "us-east-1d"
environment          = "Devlopement"
cluster_name         = "mangesh-cluster"
cluster_version      = "1.35"
key_pair_name        = "YOUR_KEY_PAIR"
ami_id               = "ami-xxxxxxxxxxxxxxxxx"
ec2_instance_type   = "t3.medium"
http_port            = 80
ssh_port             = 22
```

## 🚀 Infrastructure Deployment Workflow

### 1. Provision the AWS Infrastructure

Run the following commands from the environment folder:

```bash
cd enviroment/devlopement
terraform init
terraform plan -lock=false
terraform apply -auto-approve -lock=false
```

### 2. Connect kubectl to the EKS Cluster

```bash
aws eks update-kubeconfig --region us-east-1 --name mangesh-cluster
kubectl get nodes
```

## 🔐 Jenkins Setup on EC2

Jenkins is installed on the EC2 instance created by Terraform. Use the public IP and SSH key to access it:

```bash
ssh -i <your-key.pem> ubuntu@<ec2-public-ip>
sudo systemctl status jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Open the Jenkins UI in your browser:

```text
http://<ec2-public-ip>:8080
```

Use the password shown above to unlock Jenkins and complete the initial setup.

## 🐳 Install Docker on the Jenkins EC2 Instance

Docker is required so Jenkins can build and run container images for the application:

```bash
ssh -i <your-key.pem> ubuntu@<ec2-public-ip>
sudo apt update
sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
newgrp docker
sudo systemctl restart jenkins
sudo docker --version
```

Verify Docker is working:

```bash
sudo docker run hello-world
```

## 🚢 Install Argo CD

Argo CD can be installed to support GitOps-based deployments for the application:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

## ⚖️ Install AWS Load Balancer Controller

The AWS Load Balancer Controller manages AWS Elastic Load Balancers (ALB/NLB) for the EKS cluster.

### 1. Add the EKS Helm Chart Repository

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
```

### 2. Install the Controller using Helm

Run the following command in your terminal:

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=mangesh-cluster \
  --set serviceAccount.create=true \
  --set serviceAccount.name=mangesh-service-account \
  --set region=us-east-1 \
  --set vpcId=vpc-038e2f8e2a078d8b2 \
  --version 1.14.0
```

### 3. Verify the Installation

Check if the service account and the controller pods are successfully created and running:

```bash
# Verify the service account exists
kubectl get serviceaccount -n kube-system mangesh-service-account

# Check the status of the controller pods
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

## 🔄 Full CI/CD Flow for the Vortex Application

The Vortex repository contains the application source code and its Jenkinsfile. This pipeline automates the end-to-end deployment process to EKS.

### CI/CD Workflow

1. Jenkins pulls the latest code from the Vortex repository.
2. Jenkins builds the application image using Docker.
3. The image is pushed to a container registry.
4. The Helm chart from the Helm microservice repository is used to package and deploy the application.
5. The deployment is applied to the EKS cluster.
6. Argo CD can be used to sync and manage the release continuously.

### Typical Pipeline Stages

- Checkout source code
- Build application image
- Run tests if configured
- Push image to registry
- Update image tag in the Helm values or deployment manifest
- Deploy using Helm or kubectl
- Verify the application rollout in EKS

### Repository Mapping

- Application source: https://github.com/MangeshGot/vortex.git
- Helm chart: https://github.com/MangeshGot/helm-microservice.git
- Jenkins pipeline: https://github.com/MangeshGot/vortex/blob/main/Jenkinsfile

## 🔎 Verify the Deployment

After the pipeline runs successfully, verify that the application is reachable:

```bash
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
```

## 🧹 Cleanup

To remove the infrastructure from AWS:

```bash
cd enviroment/devlopement
terraform destroy -auto-approve -lock=false
```

## 💡 Notes

- This setup is ideal for learning and demonstrating full CI/CD pipelines on AWS EKS.
- The Terraform code is organized into reusable modules for easier maintenance.
- You can extend this environment with ingress controllers, monitoring tools, and additional automation as needed.
