# Kubernetes Security Labs

The purpose of this repo is to support a Proof of Concept on Defender for Cloud for containers and Kubernetes security

Some of this labs are based on the Kubernetes Goat and we have also added further use cases to demonstrate some of the Defender detections for containers and kubernetes

The labs will showcase the 3 main principles of Defender for Containers: Hardening, Vulnerability Management and Threat Detection

You can easily reproduce these labs for Azure Kuberntes Service environment or for a non-azure cluster like AWS EKS. We are working to show how you can test vulnerability scanning for AWS ECR

## Getting Set Up

0.	No existing cluster? Run `Setup-Environment.ps1` first. It provisions a resource group, ACR, and an AKS cluster with the `azure-policy` and `monitoring` add-ons, enables the Microsoft Defender for Containers agent (`--enable-defender`), enables the unified Microsoft Defender for Cloud **Containers** plan on the subscription, and assigns the pod security baseline initiative used later in `azure-policy-for-containers.md`.
    ```
    ./Setup-Environment.ps1 -SubscriptionId <your-subscription-id>
    ```
1.	Get access to a build machine with AZ, AWS CLI and kubectl installed. Your build machine needs to use a kubeconfig file that refers to your kubernetes cluster in scope
    For Azure, you can instruct kubectl to connect to your AKS cluster with:
        ```
        az aks get-credentials --resource-group <myResourceGroup> --name <myAKSCluster> --admin
        ```
    For AWS, use this command:
        ```
        aws eks update-kubeconfig --region <your-aws-region> --name <your-EKS-cluster>
        ```
2.  Set up the Kubernetes goat in your existing Kubernetes cluster. Some of the labs will use the scenarios described here https://madhuakula.com/kubernetes-goat/
3.	Go to the kubernetes-seclabs section and follow the labs

> Note: this repo predates the 2023 Microsoft Defender for Cloud plan consolidation. Where you see "ASC" (Azure Security Center) in scripts/comments, read it as **Microsoft Defender for Cloud**, and the old separate "Defender for Kubernetes" / "Defender for container registries" plans are now a single **Containers** plan.
