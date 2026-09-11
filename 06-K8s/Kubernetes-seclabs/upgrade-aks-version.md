# Upgrade Azure Kubernetes Service Version recommendation

> Runs on the main lab cluster (`aks-defender-k8s-lab`) - fully automatic, nothing to
> configure.

GA'd July 2026. Defender for Cloud scans AKS-managed system pods for known CVEs. When
vulnerabilities are found, this recommendation identifies the **minimum AKS version
upgrade** that resolves each one - unlike the older non-actionable recommendation, this
gives a concrete, resolvable remediation path.

## Verify

1. Go to **Microsoft Defender for Cloud** > **Recommendations**.
2. Search for **Upgrade Azure Kubernetes Service Version**.
3. Select the recommendation for `aks-defender-k8s-lab` to see the affected CVEs, their
   CVSS scores, and the minimum AKS version that includes the fix.

This recommendation only covers AKS-managed system pods, not your own workloads - use
`container-level-misconfiguration.md` and the vulnerability management labs for those.
