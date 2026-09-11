# Code-to-runtime mapping demo

Demonstrates [Defender for Cloud code-to-runtime mapping](https://learn.microsoft.com/azure/defender-for-cloud/container-image-mapping)
and the [GitHub Advanced Security integration](https://learn.microsoft.com/azure/defender-for-cloud/github-advanced-security-overview),
extending the Hardening/Vulnerability Management/Threat Detection labs in this folder with an
end-to-end code -> build -> registry -> runtime trail.

## What's in here

- `app/` - a small Flask app, intentionally pinned to an old base image and dependency
  versions so GHAS (Dependabot, CodeQL) and Defender's container vulnerability
  assessment both have real findings to correlate.
- `deployment.yaml` - Kubernetes manifests (namespace, deployment, service) deployed
  into the `threatapps` namespace on the AKS cluster from `Setup-Environment.ps1`.
- `../../.github/workflows/code-to-runtime-demo.yml` - builds the image, tags it with
  the immutable commit SHA, adds OCI labels (`docker/metadata-action`) so Defender can
  map the running container back to this repo/commit without needing a DevOps
  connector, pushes to ACR, and deploys to AKS. Authenticates to Azure with OIDC
  (federated credential) - no stored secrets.

## Prerequisites

1. Run `../Setup-Environment.ps1` first to provision the AKS cluster, ACR and enable
   Defender for Containers.
2. Create an Entra ID app registration with a federated credential trusting
   `repo:<owner>@<owner-id>/<repo>@<repo-id>:ref:refs/heads/main` (GitHub includes the
   numeric owner/repo IDs in the OIDC subject claim - check the actual claim from a
   failed `azure/login` run if the subject format ever changes).
3. Grant that app's service principal `AcrPush` on the ACR and
   `Azure Kubernetes Service RBAC Cluster Admin` + `Cluster User Role` on the AKS
   cluster.
4. Set the following repo variables (Settings -> Secrets and variables -> Actions ->
   Variables): `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`,
   `ACR_NAME`, `AKS_CLUSTER_NAME`, `AKS_RESOURCE_GROUP`.
5. Onboard this GitHub account/org to Defender for Cloud (Environment settings -> Add
   environment -> GitHub) and make sure this repository is included in the GitHub
   App's repository access list.

## Validate the mapping

Give it up to a few hours after the first successful workflow run, then in the Azure
portal go to **Defender for Cloud -> Cloud Security Explorer** and query
**Container Images -> Pushed by code repositories** to see the running container
mapped back to this repository and commit.
