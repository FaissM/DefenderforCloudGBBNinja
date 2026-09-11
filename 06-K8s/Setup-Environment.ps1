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
    [string]$NodeVmSize = "Standard_D4s_v6"
)

$ErrorActionPreference = "Stop"

# az CLI is an external command: a non-zero exit code does not raise a terminating
# error in PowerShell on its own, so we check $LASTEXITCODE after every call.
function Invoke-Az {
    param([Parameter(Mandatory = $true)][string]$Command)
    Invoke-Expression $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $($LASTEXITCODE): $Command"
    }
}

Invoke-Az "az account set --subscription $SubscriptionId"

# 1 - Resource group
Invoke-Az "az group create --name $ResourceGroup --location $Location"

# 2 - Log Analytics workspace (used by Container Insights + Defender)
Invoke-Az "az monitor log-analytics workspace create --resource-group $ResourceGroup --workspace-name $WorkspaceName --location $Location"
$workspaceId = az monitor log-analytics workspace show --resource-group $ResourceGroup --workspace-name $WorkspaceName --query id -o tsv

# 3 - Azure Container Registry
Invoke-Az "az acr create --resource-group $ResourceGroup --name $AcrName --sku Standard --admin-enabled false"

# 4 - Enable Microsoft Defender for Cloud - unified "Containers" plan at subscription scope
$currentTier = az security pricing show --name Containers --query pricingTier -o tsv
if ($currentTier -eq "Standard") {
    Write-Host "Defender for Cloud 'Containers' plan is already Standard - skipping."
} else {
    az security pricing create --name Containers --tier Standard
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to enable the Defender for Cloud Containers plan."
    }
}

# 5 - AKS cluster with Azure Policy add-on, monitoring add-on, and Defender sensor enabled
Invoke-Az "az aks create --resource-group $ResourceGroup --name $AksClusterName --location $Location --node-count $NodeCount --node-vm-size $NodeVmSize --enable-addons azure-policy,monitoring --workspace-resource-id $workspaceId --enable-defender --attach-acr $AcrName --generate-ssh-keys"

# 6 - Get kubectl credentials
Invoke-Az "az aks get-credentials --resource-group $ResourceGroup --name $AksClusterName --overwrite-existing"

# 7 - Assign the pod security baseline initiative to the resource group, used in azure-policy-for-containers.md
$rgId = az group show --name $ResourceGroup --query id -o tsv
$initiativeName = az policy set-definition list --query "[?displayName=='Kubernetes cluster pod security baseline standards for Linux-based workloads'].name | [0]" -o tsv
if ([string]::IsNullOrWhiteSpace($initiativeName)) {
    throw "Could not resolve the built-in policy initiative name."
}
# NOTE: passing the full policySetDefinition resource id together with --display-name
# triggers an `az policy assignment create` resolution bug (PolicySetDefinitionNotFound) -
# passing the bare definition name works around it.
Invoke-Az "az policy assignment create --name `"k8s-pod-security-baseline`" --scope `"$rgId`" --policy-set-definition `"$initiativeName`" --location $Location --mi-system-assigned --identity-scope `"$rgId`" --role Contributor"

Write-Host "Environment ready."
Write-Host "Resource Group : $ResourceGroup"
Write-Host "ACR            : $AcrName"
Write-Host "AKS Cluster    : $AksClusterName"
Write-Host "Next: follow README.md step 2 onwards (Kubernetes Goat + kubernetes-seclabs)."
Write-Host "Note: Defender alerts/recommendations can take 15 mins - a few hours to surface."
