# 🚀 Amazon EKS Manual & Modular Deployment with Terraform

This project provisions a highly secure, production-grade networking foundation and an Amazon EKS cluster on AWS using reusable, native Terraform modules. It orchestrates a complete isolated Virtual Private Cloud (VPC), private computing environments, and a persistent block storage (EBS) engine.

## 📁 Project Structure

```text
03_EKS_Deploy_using_modules/
├── README.md
├── enviroment/
│   └── devlopement/
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       ├── variables.tf
│       └── outputs.tf
└── modules/
    ├── eks/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── internet_gateway/
    ├── routes/
    ├── subnets/
    └── vpc/
```

## 🛠️ What This Project Creates

*   **VPC Security Isolation:** A modular Virtual Private Cloud spanning targeted Availability Zones.
*   **Segmented Routing Architecture:** Public subnets for incoming ingress traffic routes and dedicated private subnets to isolate your application nodes.
*   **Gateway Endpoints:** Explicit Internet Gateways (IGW) and NAT Gateway topologies supporting secure outbound updates from private networks.
*   **Native Amazon EKS Cluster Control Plane:** A raw, highly reusable Kubernetes API server engine.
*   **Private Compute Node Group:** Deploys high-performance **`m7i-flex.large`** EC2 computing nodes safely locked away inside your private subnets.
*   **Integrated Core Add-ons:** Fully automates the system runtime installations for `vpc-cni`, `coredns`, `kube-proxy`, and the `eks-pod-identity-agent`.
*   **Dynamic Storage Layer:** Provisions the `aws-ebs-csi-driver` tied to an IAM Pod Identity mapping, enabling automated provisioning of persistent disks.

## 📋 Prerequisites

Before running deployment scripts, verify that you have configured your environment workstation with the following tools:
*   [Terraform CLI](https://hashicorp.com) (>= 1.5.0)
*   [AWS CLI](https://amazon.com) (Configured with administrative cloud user profile tokens)
*   [kubectl](https://kubernetes.io) (The generic terminal execution client used to communicate with Kubernetes)

## ⚙️ Configure Environment Variables

Define your infrastructure properties directly inside the target parameter sheet:

*   `enviroment/devlopement/terraform.tfvars`

Example Configuration:
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
cluster_version      = "1.31"
```

---

## 🚀 Usage Workflow

### 1. Initialize & Provision Cloud Hardware
Navigate straight to your target execution folder:
```bash
cd enviroment/devlopement
```

Index your module code blocks and cache mandatory provider binary plugins:
```bash
terraform init
```

Review the structural additions (VPC networks, subnets, IAM Roles, and Node Groups) via a dry-run check:
```bash
terraform plan -lock=false
```

Deploy the entire architecture directly into your AWS account. *Note: Building the secure private networking maps and EKS control plane components takes roughly 12 to 15 minutes.*
```bash
terraform apply -auto-approve -lock=false
```

### 2. Connect Your Local Terminal Context
Once the script successfully terminates, map your local terminal workspace configuration credentials straight to your new cloud API server control plane endpoint:
```bash
aws eks update-kubeconfig --region us-east-1 --name mangesh-cluster
```

Verify that your local machine successfully establishes a secure handshake and can see both of your `m7i-flex.large` worker node instances showing a `Ready` status:
```bash
kubectl get nodes
```

### 3. Deploy a Stateful Application (Dynamic PVC/PV Verification)
To test your cluster's automated block storage engine, create a standard configuration manifest named `storage-app.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp2 # Standard default block storage profile
  resources:
    requests:
      storage: 4Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: storage-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: storage-app
  template:
    metadata:
      labels:
        app: storage-app
    spec:
      containers:
      - name: data-container
        image: alpine
        command: ["/bin/sh", "-c", "while true; do date >> /data/log.txt; sleep 5; done"]
        volumeMounts:
        - name: persistent-storage
          mountPath: /data
      volumes:
      - name: persistent-storage
        persistentVolumeClaim:
          claimName: ebs-pvc
```

Push the application system resources live:
```bash
kubectl apply -f storage-app.yaml
```

Verify that the cluster communicates with AWS to provision a physical EBS disk, automatically shifting your Persistent Volume Claim (PVC) state to `Bound`:
```bash
kubectl get pvc
kubectl get pv
```

Stream the log file directly out of the active container directory to verify that background data writes to your persistent AWS cloud drive are functioning properly:
```bash
kubectl exec -it deployment/storage-app -- cat /data/log.txt
```

---

## 🧹 Cleaning Up Infrastructure

To prevent unexpected billing charges on your AWS account, tear down your lab configurations cleanly. 

First, purge your stateful containers from inside your cluster so your cloud volume can be safely unmounted and destroyed by the driver tracking framework:
```bash
kubectl delete -f storage-app.yaml
```

Once the workloads are removed, use Terraform to automatically target, destroy, and safely sweep your entire cloud infrastructure map out of your account without leaving orphaned nodes or network interfaces behind:
```bash
terraform destroy -auto-approve -lock=false
```
