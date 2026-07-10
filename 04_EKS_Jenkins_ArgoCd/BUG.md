# **Troubleshooting: AWS Load Balancer Controller "No EC2 IMDS Role Found"**

## **Overview**

When deploying the AWS Load Balancer Controller on Amazon EKS using **Terraform** (for EKS Pod Identity) and **Helm** (for the controller deployment), the controller pods failed to provision an Application Load Balancer (ALB) from an Ingress resource.

## **The Issue**

After applying an Ingress resource, the ADDRESS field remained blank. Checking the AWS Load Balancer Controller logs using kubectl logs -n kube-system deployment/aws-load-balancer-controller revealed repeating errors:

Plaintext

Reconciler error... operation error Elastic Load Balancing v2: DescribeLoadBalancers, get identity: get credentials: failed to refresh cached credentials, no EC2 IMDS role found, operation error ec2imds: GetMetadata, canceled, context deadline exceeded

## **Root Cause**

The issue was caused by a **Namespace Mismatch** between the AWS IAM permission mapping and the actual Kubernetes pod location.

- **Helm Setup:** The controller was correctly installed into the kube-system namespace.
- **Terraform Setup:** The aws_eks_pod_identity_association resource in Terraform was relying on a namespace variable that defaulted to "default".

Because Terraform told AWS to grant IAM permissions to a ServiceAccount in the default namespace, the controller pods running in the kube-system namespace were denied access to AWS APIs. When the pods failed to find Pod Identity credentials, they fell back to checking the worker node's EC2 instance profile (IMDS), which also failed, resulting in the error.

## **The Fix**

### **Step 1: Correct the Terraform Variable**

Update the variables file (e.g., variables.tf or terraform.tfvars) so the EKS Pod Identity mapping aligns exactly with the Helm deployment namespace.

**Before (variables.tf):**

Terraform

variable "namespace" {

type = string

description = "The Kubernetes namespace where your app runs"

default = "default" # <-- THE BUG

}

**After (variables.tf):**

Terraform

variable "namespace" {

type = string

description = "The Kubernetes namespace where your app runs"

default = "kube-system" # <-- THE FIX

}

### **Step 2: Apply the Infrastructure Changes**

Run Terraform to update the EKS Pod Identity association in AWS:

Bash

terraform apply

### **Step 3: Restart the Controller Pods**

Kubernetes pods do not automatically pull new EKS Pod Identity credentials if the association is created or updated _after_ the pods start. You must restart the deployment to force the pods to pick up the newly injected AWS credentials:

Bash

kubectl rollout restart deployment aws-load-balancer-controller -n kube-system

### **Step 4: Verify the Fix**

Check the logs of the newly spun-up pods. You should see a clean startup sequence followed by:

Plaintext

successfully built model

Finally, check your Ingress resource to confirm AWS has provisioned the Application Load Balancer and assigned a public DNS name:

Bash

kubectl get ingress

_(The ADDRESS column should now display the .elb.amazonaws.com URL within 2-3 minutes)._

## **Key Takeaway**

When using the modern **EKS Pod Identity Addon** (aws_eks_pod_identity_association), the IAM Role is strictly bound to a specific **Namespace** and **ServiceAccount name**. These values in your IaC (Terraform) must be 1:1 identical to the values passed into your Helm charts