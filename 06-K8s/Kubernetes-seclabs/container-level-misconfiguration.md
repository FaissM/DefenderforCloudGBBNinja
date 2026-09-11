# Container-level misconfiguration recommendations (agentless)

> Runs on the main lab cluster (`aks-defender-k8s-lab`) - purely passive, no setup
> required. Already active: `AgentlessDiscoveryForKubernetes` is enabled on this
> subscription's Containers plan.

GA'd July 2026, this replaces the older cluster-level Azure Policy/Gatekeeper checks
(HostPath volume restrictions, allowed ports, host networking, CAP_SYS_ADMIN, AppArmor -
all deprecated) with agentless, **container-level** KSPM recommendations that assess
individual containers instead of entire clusters.

Covers: CPU/memory limits, trusted registries, privilege escalation, sensitive host
namespaces, read-only root filesystem, HTTPS-only ingress, automounting API credentials,
Linux capabilities, privileged containers, and running as root.

## Verify it's working

No deployment needed - the same non-compliant pods deployed for the other hardening labs
in this folder (`capsysadmin.md`, `privilege-container.md`, `container-as-root.md`, etc.)
are enough. In the Azure portal:

1. Go to **Microsoft Defender for Cloud** > **Recommendations**.
2. Filter by resource type **Kubernetes container** (or search "container").
3. Confirm findings appear at the individual **container** level (not just the cluster),
   for the pods already deployed by the other labs in this folder.

See the full list of checks in the
[container security recommendations reference](https://learn.microsoft.com/azure/defender-for-cloud/recommendations-reference-container).
