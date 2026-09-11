# DNS Detection for Kubernetes

> Runs on `aks-defender-advanced-lab` - requires the Helm-deployed Defender sensor
> (`Setup-Advanced-Environment.ps1`). No extra configuration needed - DNS Detection is on
> automatically once the sensor is running.

DNS Detection monitors DNS queries from containerized workloads to detect suspicious
activity, such as communication with known-malicious domains or DNS tunneling.

## Test it

From inside a pod on the advanced cluster, resolve a domain from the
[Defender for Cloud alert validation list](https://learn.microsoft.com/azure/defender-for-cloud/alert-validation)
(a safe, Microsoft-provided domain specifically designed to trigger a test detection
without any real risk):

```
kubectl exec -it <pod-name> -n threatapps -- /bin/bash
nslookup any.thisisnotarealdomain-mdc-test.com
```

(Check the current alert-validation doc for the exact test domain/IP, as Microsoft
periodically rotates these.)

## Verify

A **Suspicious DNS query** (or similar) alert appears in Defender for Cloud within a few
minutes, showing the querying pod, the resolved domain, and the detection reason.
