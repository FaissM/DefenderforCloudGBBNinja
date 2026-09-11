# Microsoft Defender for Cloud

Hands-on labs to demo and test **Microsoft Defender for Cloud** (formerly Azure
Security Center / ASC) against real Azure workloads.

> Fork of [davisanc/DefenderforCloudGBBNinja](https://github.com/davisanc/DefenderforCloudGBBNinja),
> restarted from scratch and kept up to date with the current Defender for Cloud
> plan structure and feature set (unified Containers plan, Defender CSPM, gated
> deployment, code-to-runtime mapping, GitHub Advanced Security integration).

## Labs

| Folder | Workload |
|---|---|
| [06-K8s](06-K8s) | **Defender for Containers** - AKS security labs covering hardening (Azure Policy/Gatekeeper + agentless container-level KSPM), vulnerability management, threat detection, gated deployment, anti-malware, binary drift, DNS detection, and a [code-to-runtime + GitHub Advanced Security demo](06-K8s/code-to-runtime-demo). |
| [07-ServerlessContainers](07-ServerlessContainers) | **Defender CSPM for serverless containers** - agentless discovery, posture, and attack path analysis for Azure Container Apps and Azure Container Instances. |

## Getting started

Each folder is self-contained with its own README/lab instructions.

```
cd 06-K8s
./Setup-Environment.ps1 -SubscriptionId <your-subscription-id>
```

Requires the Azure CLI (`az`) logged in, and `kubectl`. See each folder's README for the
full lab walkthrough.
