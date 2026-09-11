# Binary drift detection and blocking

> Runs on `aks-defender-advanced-lab` - requires the Helm-deployed Defender sensor
> (binary drift blocking additionally requires sensor version 0.10.2+, installed by
> `Setup-Advanced-Environment.ps1`).

Binary drift happens when a container runs an executable that didn't come from the
original image. Since container images should be immutable, any process started from a
binary outside the original image is treated as suspicious.

This reuses the exact technique from `container-escape.md`, but this time on the
sensor-enabled cluster so Defender can catch it automatically instead of you needing to
notice the compromise yourself.

## Test it

Exec into a running pod and install/run a binary that wasn't part of the original image:

```
kubectl exec -it <pod-name> -n threatapps -- /bin/bash
apt update && apt install -y netcat-openbsd
nc -lvp 4444 &
```

`netcat` wasn't part of the original `nginx`/app image, so running it counts as drift.

## Configure alert vs. block rules

1. Sign in to the [Azure portal](https://portal.azure.com).
2. Go to **Microsoft Defender for Cloud** > **Environment settings**.
3. Select **Containers drift policy**.
4. Select **Add rule**, choose **Drift detection alert** or **Drift detection blocking**.
5. Scope it to the `aks-defender-advanced-lab` cluster.
6. Select **Apply**, then **Save**. Sensors update within ~30 minutes.

## Verify

A high-severity **binary drift** alert appears in Defender for Cloud, naming the
unauthorized process and the pod/container it ran in. With a blocking rule in place, the
process is prevented from executing instead of just alerted on.
