# Serverless container posture and misconfiguration recommendations

Once Defender CSPM discovers the Container App / Container Instance deployed by
`../Setup-Environment.ps1`, it evaluates them for misconfigurations and vulnerability
findings the same way it does for other resource types.

## Verify

1. Sign in to the [Azure portal](https://portal.azure.com).
2. Go to **Microsoft Defender for Cloud** > **Inventory**.
3. Filter by resource type **Container App** / **Container Instance** and confirm
   `ca-defender-serverless-demo` and `aci-defender-serverless-demo` are discovered.
4. Go to **Recommendations** and search for the resource name. Expect findings related
   to public network exposure, since both resources were deliberately deployed with
   public ingress/IP.

## What to look for

- Recommendations flagging unrestricted public network access
- Vulnerability assessment findings for the base images used
   (`mcr.microsoft.com/k8se/quickstart`, `mcr.microsoft.com/azuredocs/aci-helloworld`)
