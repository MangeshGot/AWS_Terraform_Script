# 📝 Amazon EKS Manual Deployment & Storage Reference Guide

This document outlines the step-by-step procedure implemented to successfully provision a traditional, production-ready Amazon EKS cluster with dynamic AWS EBS persistent volumes.

---

## 🛠️ Step 1: Pre-requisites & IAM Configuration
Before launching any resources in the AWS Console, create two distinct IAM security identities to handle access management:

*   **EKS Cluster Role**: Created an IAM role with the `AmazonEKSClusterPolicy` managed permissions attached, allowing the Kubernetes control plane engine to coordinate standard AWS cloud assets.
*   **Worker Node Role**: Created an EC2 IAM role with three mandatory foundational policies attached:
    *   `AmazonEKSWorkerNodePolicy`
    *   `AmazonEC2ContainerRegistryReadOnly`
    *   `AmazonEKS_CNI_Policy`

---

## 🧠 Step 2: Provisioning the EKS Control Plane
Using the graphical AWS Management Console UI, search for **Elastic Kubernetes Service** and choose **Custom Configuration** to maintain granular deployment control:

*   **EKS Auto Mode**: Explicitly toggled **OFF** to retain manual administration over backend server scaling and cluster component layers.
*   **Networking**: Configured high availability by selecting **all 4 subnets** (2 public subnets + 2 private subnets) spread across isolated Availability Zones.
*   **Endpoint Access**: Selected **Public and Private** access. This allows you to securely send terminal commands from your home machine while keeping internal node routing secure.

---

## 🔌 Step 3: Configuring Core Add-ons & EKS Pod Identity
In the cluster plugins setup wizard, apply individual system packages. Use **EKS Pod Identity** (`pods.eks` trust relationships) to attach explicit IAM roles directly to service accounts:

*   **Amazon VPC CNI**: Manages underlying cluster pod networking. Tied to a dedicated CNI role.
*   **CoreDNS & kube-proxy**: Left on standard default versions to govern internal domain naming resolution and container load balancing packet rules.
*   **Amazon EBS CSI Driver**: Linked directly to your custom `my-eks-ebs-csi-driver` identity role, giving Kubernetes authorization to provision block storage resources dynamically.
*   **Amazon EFS CSI Driver**: Linked directly to your custom `my-eks-efs-csi-driver` identity role for potential shared network file systems.

---

## 💪 Step 4: Adding Compute Node Worker Groups
Once the central control plane status toggled to a green **Active** state, initialize the underlying server hardware:

*   Navigate directly to your cluster's **Compute** tab and click **Add Node Group**.
*   Assign your pre-configured `my-eks-node-role` to the system profile.
*   **Hardware Selection**: Selected **`m7i-flex.large`** compute instances (featuring 2 vCPUs and 8 GiB RAM per machine), balancing modern performance efficiency with cost reduction.
*   **Scaling Configuration**:
    *   **Minimum Nodes**: 1
    *   **Maximum Nodes**: 3
    *   **Desired Nodes**: 2 (Ensures two server instances spin up instantly).
*   **Subnet Placement (Crucial)**: Manually uncheck the public subnets and choose **ONLY your 2 private subnets** to isolate application servers from the open internet.

---

## 💻 Step 5: Syncing Local Terminal Credentials
Once the node groups show an active status, connect your local machine's CLI directly to the running cloud infrastructure:

```bash
# Sync your local kubeconfig profile context with the cloud control plane
aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>

# Verify that both worker servers are registered and healthy
kubectl get nodes
```

---

## 💾 Step 6: Deploying Dynamic Storage (PVC & PV Deployment)
Because your cluster runs the legacy `gp2` storage engine profile, deploy stateful configurations matching this standard. Create a deployment manifest file named `storage-app.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp2
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

### Apply and Verify the Architecture:
```bash
# Push the manifest configuration to your cluster
kubectl apply -f storage-app.yaml

# Check the persistent claim status (Should transition directly to 'Bound')
kubectl get pvc

# Verify that Kubernetes automatically created a physical cloud PV drive link
kubectl get pv

# Stream container system updates to confirm data writes to the persistent block storage
kubectl exec -it deployment/storage-app -- cat /data/log.txt
```
