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

## Advanced labs (separate cluster)

A few 2026 Defender for Containers capabilities change cluster-wide behavior in ways
that would break the labs above if applied to the same cluster (for example, admission
Block rules would reject the same non-compliant pods those labs rely on deploying
successfully so Defender can detect them afterwards). These run on a second,
purpose-built cluster instead:

```
./Setup-Advanced-Environment.ps1 -SubscriptionId <your-subscription-id>
```

This provisions `aks-defender-advanced-lab` with the Defender sensor installed directly
via Helm (no AKS security profile, so there's no profile-vs-Helm migration to manage),
with the anti-malware collector enabled. Labs:

- [gated-deployment-misconfiguration.md](Kubernetes-seclabs/gated-deployment-misconfiguration.md)
- [gated-deployment-vulnerability.md](Kubernetes-seclabs/gated-deployment-vulnerability.md)
- [anti-malware-detection.md](Kubernetes-seclabs/anti-malware-detection.md)
- [binary-drift-detection.md](Kubernetes-seclabs/binary-drift-detection.md)
- [dns-detection.md](Kubernetes-seclabs/dns-detection.md)

Two more 2026 features are fully passive/automatic and are verified directly on the main
lab cluster (`aks-defender-k8s-lab`), no separate cluster needed:

- [container-level-misconfiguration.md](Kubernetes-seclabs/container-level-misconfiguration.md)
- [upgrade-aks-version.md](Kubernetes-seclabs/upgrade-aks-version.md)
