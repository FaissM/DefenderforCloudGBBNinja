# Attack path analysis for serverless containers

Defender CSPM's attack path analysis maps how an internet-exposed serverless container
could be used as an entry point for an attacker to reach other resources.

## Verify

1. Sign in to the [Azure portal](https://portal.azure.com).
2. Go to **Microsoft Defender for Cloud** > **Attack path analysis**.
3. Look for a path originating from `ca-defender-serverless-demo` or
   `aci-defender-serverless-demo`, flagged for internet exposure.
4. Select the path to see the full chain and Defender's remediation guidance.

## Explore with Cloud Security Explorer

1. Go to **Microsoft Defender for Cloud** > **Cloud Security Explorer**.
2. Build a query: **Container App** (or **Container Instance**) -> **Is publicly
   accessible** -> **+** to add further hops (for example, connected identities or data
   stores) and see the full blast radius of the exposure.
