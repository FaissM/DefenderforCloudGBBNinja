# Kubernetes Security Labs

The purpose of this folder is to support a Proof of Concept on Defender for Cloud for
containers and Kubernetes security on Azure Kubernetes Service (AKS).

Some of these labs are based on the Kubernetes Goat and we have also added further use
cases to demonstrate some of the Defender detections for containers and kubernetes.

The labs showcase the 3 main principles of Defender for Containers: Hardening,
Vulnerability Management and Threat Detection.

## Getting Set Up

0. No existing cluster? Run `Setup-Environment.ps1` first. It provisions a resource
   group, ACR, and an AKS cluster with the `azure-policy` and `monitoring` add-ons,
   enables the Microsoft Defender for Containers agent (`--enable-defender`), enables
   the unified Microsoft Defender for Cloud **Containers** plan on the subscription,
   and assigns the pod security baseline initiative used later in
   `azure-policy-for-containers.md`.
   ```
   ./Setup-Environment.ps1 -SubscriptionId <your-subscription-id>
   ```
1. Get access to a build machine with the Azure CLI (`az`) and `kubectl` installed.
   Connect kubectl to your AKS cluster with:
   ```
   az aks get-credentials --resource-group <myResourceGroup> --name <myAKSCluster> --admin
   ```
2. Set up the Kubernetes Goat in your cluster. Some of the labs use the scenarios
   described here: https://madhuakula.com/kubernetes-goat/
3. Go to the `Kubernetes-seclabs` section and follow the labs.

> Note: this repo predates the 2023 Microsoft Defender for Cloud plan consolidation.
> Where you see "ASC" (Azure Security Center) in scripts/comments, read it as
> **Microsoft Defender for Cloud**, and the old separate "Defender for Kubernetes" /
> "Defender for container registries" plans are now a single **Containers** plan.
