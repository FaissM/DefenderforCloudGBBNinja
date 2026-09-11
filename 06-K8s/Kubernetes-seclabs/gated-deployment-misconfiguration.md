# Kubernetes misconfiguration enforcement (gated deployment - Block mode)

> Runs on `aks-defender-advanced-lab` (see `../Setup-Advanced-Environment.ps1`), not the
> main lab cluster - Block mode would reject the intentionally non-compliant pods used
> by `capsysadmin.md`, `privilege-container.md`, `container-as-root.md`, etc.

Kubernetes misconfiguration enforcement evaluates Kubernetes resources **before** they're
admitted into the cluster, so it can audit or block deployments that don't meet Microsoft
security best-practice rules - as opposed to the other hardening labs in this folder, which
detect non-compliance only *after* the pod is already running.

A default rule, **Default K8s misconfiguration rule**, is created automatically in **Audit**
mode once the Defender sensor is running on the cluster.

## Configure a Block rule

1. Sign in to the [Azure portal](https://portal.azure.com).
2. Go to **Microsoft Defender for Cloud** > **Environment settings**.
3. Select **Security rules**.
4. Select **Gated deployment** > **Misconfigurations**.
5. Select **Create new policy**.
6. Set an **Action** of **Block**, scope it to the `aks-defender-advanced-lab` cluster.
7. Enable at least the following built-in rules: privileged containers, non-root
   execution, CAP_SYS_ADMIN / Linux capabilities, host namespace isolation.
8. Select **Add policy**.

## Test it

Try to deploy the same privileged pod manifest used in `privilege-container.md`:

```
kubectl apply -f privileged-pod.yaml
```

With the rule in **Block** mode, the deployment is rejected at admission time - compare
this with the same manifest succeeding (and only being flagged afterwards) on the main
lab cluster.

## Verify

Go to **Environment settings** > **Security rules** > **Gated deployment** >
**Admission Monitoring** to see the rejected admission event, including the container
image digest, the rule that triggered, and the specific violated conditions.
