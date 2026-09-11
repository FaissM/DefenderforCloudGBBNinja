###---------------------------------------------------------------------------------
### Bootstraps an Azure test environment for the Kubernetes Security Labs in this folder:
###   - Resource Group
###   - Azure Container Registry (ACR)
###   - AKS cluster with:
###       * azure-policy add-on (Gatekeeper) for hardening labs
###       * monitoring add-on (Container Insights)
###       * Microsoft Defender for Containers agent (--enable-defender)
###       * ACR attached for pull access
###   - Microsoft Defender for Cloud "Containers" plan enabled on the subscription
###     (unified plan, replaces the old separate Kubernetes/Container Registry plans)
###   - "Kubernetes cluster pod security baseline standards for Linux-based workloads"
###     policy initiative assigned to the resource group, for the azure-policy-for-containers.md lab
###
### Requires: Azure CLI logged in (az login), Owner/Contributor + Security Admin
### on the target subscription, aks-preview features not required.
###---------------------------------------------------------------------------------

param(
    [Parameter(Mandatory = $true)][string]$SubscriptionId,
    [string]$Location = "eastus",
    [string]$ResourceGroup = "rg-defender-k8s-lab",
    [string]$AcrName = "acrdefenderk8slab$((Get-Random -Maximum 9999))",
    [string]$AksClusterName = "aks-defender-k8s-lab",
    [string]$WorkspaceName = "log-defender-k8s-lab",
    [int]$NodeCount = 2,
    [string]$NodeVmSize = "Standard_D2s_v5"
)

$ErrorActionPreference = "Stop"

az account set --subscription $SubscriptionId

# 1 - Resource group
az group create --name $ResourceGroup --location $Location

# 2 - Log Analytics workspace (used by Container Insights + Defender)
az monitor log-analytics workspace create `
    --resource-group $ResourceGroup `
    --workspace-name $WorkspaceName `
    --location $Location
$workspaceId = az monitor log-analytics workspace show `
    --resource-group $ResourceGroup --workspace-name $WorkspaceName --query id -o tsv

# 3 - Azure Container Registry
az acr create --resource-group $ResourceGroup --name $AcrName --sku Standard --admin-enabled false

# 4 - Enable Microsoft Defender for Cloud - unified "Containers" plan at subscription scope
az security pricing create --name Containers --tier Standard

# 5 - AKS cluster with Azure Policy add-on, monitoring add-on, and Defender sensor enabled
az aks create `
    --resource-group $ResourceGroup `
    --name $AksClusterName `
    --location $Location `
    --node-count $NodeCount `
    --node-vm-size $NodeVmSize `
    --enable-addons azure-policy,monitoring `
    --workspace-resource-id $workspaceId `
    --enable-defender `
    --attach-acr $AcrName `
    --generate-ssh-keys

# 6 - Get kubectl credentials
az aks get-credentials --resource-group $ResourceGroup --name $AksClusterName --overwrite-existing

# 7 - Assign the pod security baseline initiative to the resource group, used in azure-policy-for-containers.md
$rgId = az group show --name $ResourceGroup --query id -o tsv
$initiativeId = az policy set-definition list `
    --query "[?displayName=='Kubernetes cluster pod security baseline standards for Linux-based workloads'].id | [0]" `
    -o tsv
az policy assignment create `
    --name "k8s-pod-security-baseline" `
    --display-name "Kubernetes cluster pod security baseline standards for Linux-based workloads" `
    --scope $rgId `
    --policy-set-definition $initiativeId `
    --location $Location `
    --mi-system-assigned `
    --identity-scope $rgId `
    --role Contributor

Write-Host "Environment ready."
Write-Host "Resource Group : $ResourceGroup"
Write-Host "ACR            : $AcrName"
Write-Host "AKS Cluster    : $AksClusterName"
Write-Host "Next: follow README.md step 2 onwards (Kubernetes Goat + kubernetes-seclabs)."
Write-Host "Note: Defender alerts/recommendations can take 15 mins - a few hours to surface."
