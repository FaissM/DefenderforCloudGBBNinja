# Microsoft Defender for Cloud

Hands-on labs to demo and test **Microsoft Defender for Cloud** (formerly Azure
Security Center / ASC) against real Azure workloads.

> Fork of [davisanc/DefenderforCloudGBBNinja](https://github.com/davisanc/DefenderforCloudGBBNinja),
> restarted from scratch with only the Defender for Containers lab kept and modernized
> for the current Defender for Cloud plan structure (unified Containers plan, Defender
> CSPM). More workload labs will be added over time.

## Labs

| Folder | Workload |
|---|---|
| [06-K8s](06-K8s) | **Defender for Containers** - AKS + ACR security labs covering hardening (Azure Policy/Gatekeeper), vulnerability management, and threat detection. Includes [`Setup-Environment.ps1`](06-K8s/Setup-Environment.ps1) to bootstrap a full test environment, and a [code-to-runtime + GitHub Advanced Security demo](06-K8s/code-to-runtime-demo). |

## Getting started

```
cd 06-K8s
./Setup-Environment.ps1 -SubscriptionId <your-subscription-id>
```

Requires the Azure CLI (`az`) logged in, and `kubectl`. See [06-K8s/README.md](06-K8s/README.md)
for the full lab walkthrough.
