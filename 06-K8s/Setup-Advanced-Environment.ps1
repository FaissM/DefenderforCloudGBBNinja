###---------------------------------------------------------------------------------
### Bootstraps a SECOND AKS cluster dedicated to the newer (2026) Defender for
### Containers capabilities that would conflict with the labs already running on
### aks-defender-k8s-lab if applied there (see analysis in README.md):
###   - Kubernetes misconfiguration enforcement (gated deployment, Block mode)
###   - Vulnerability-based gated deployment
###   - Anti-malware detection/blocking
###   - Binary drift detection/blocking
###   - DNS Detection for Kubernetes
###
### Unlike Setup-Environment.ps1, this cluster is created WITHOUT --enable-defender
### (the AKS security profile). The Defender sensor is installed purely via Helm from
### the start, so there is no profile-vs-Helm migration/conflict to manage.
###
### Reuses the resource group, ACR, and Log Analytics workspace created by
### Setup-Environment.ps1 - run that script first.
###---------------------------------------------------------------------------------

param(
    [Parameter(Mandatory = $true)][string]$SubscriptionId,
    [string]$Location = "westeurope",
    [string]$ResourceGroup = "rg-defender-k8s-lab",
    [string]$AcrName,
    [string]$WorkspaceName = "log-defender-k8s-lab",
    [string]$AksClusterName = "aks-defender-advanced-lab",
    [int]$NodeCount = 2,
    [string]$NodeVmSize = "Standard_D4s_v6"
)

$ErrorActionPreference = "Stop"

function Invoke-Az {
    param([Parameter(Mandatory = $true)][string]$Command)
    Invoke-Expression $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $($LASTEXITCODE): $Command"
    }
}

Invoke-Az "az account set --subscription $SubscriptionId"

if ([string]::IsNullOrWhiteSpace($AcrName)) {
    $AcrName = az acr list --resource-group $ResourceGroup --query "[0].name" -o tsv
    if ([string]::IsNullOrWhiteSpace($AcrName)) {
        throw "No ACR found in $ResourceGroup. Pass -AcrName explicitly or run Setup-Environment.ps1 first."
    }
}
$workspaceId = az monitor log-analytics workspace show --resource-group $ResourceGroup --workspace-name $WorkspaceName --query id -o tsv

# 1 - AKS cluster WITHOUT --enable-defender: the sensor is installed via Helm below,
# not the AKS security profile, to avoid the profile-vs-Helm migration conflict.
Invoke-Az "az aks create --resource-group $ResourceGroup --name $AksClusterName --location $Location --node-count $NodeCount --node-vm-size $NodeVmSize --enable-addons monitoring --workspace-resource-id $workspaceId --attach-acr $AcrName --enable-oidc-issuer --generate-ssh-keys"

Invoke-Az "az aks get-credentials --resource-group $ResourceGroup --name $AksClusterName --overwrite-existing"

# 2 - Install the Defender for Containers sensor via Helm, with the anti-malware
# collector enabled (binary drift and DNS Detection are on by default once the
# sensor is running - no extra flags needed).
$tenantId = az account show --query tenantId -o tsv
Invoke-Az "helm install defender-k8s oci://mcr.microsoft.com/azuredefender/microsoft-defender-for-containers --create-namespace --namespace mdc --set global.cloudIdentifiers.Azure.subscriptionId=$SubscriptionId --set global.cloudIdentifiers.Azure.resourceGroupName=$ResourceGroup --set global.cloudIdentifiers.Azure.clusterName=$AksClusterName --set global.cloudIdentifiers.Azure.region=$Location --set microsoft-defender-for-containers-sensor.antimalwareCollector.enabled=true"

Write-Host "Advanced environment ready."
Write-Host "AKS Cluster : $AksClusterName (Helm-deployed Defender sensor, mdc namespace)"
Write-Host "Next: configure gated deployment rules in the portal - see"
Write-Host "  Kubernetes-seclabs/gated-deployment-misconfiguration.md"
Write-Host "  Kubernetes-seclabs/gated-deployment-vulnerability.md"
Write-Host "  Kubernetes-seclabs/anti-malware-detection.md"
Write-Host "  Kubernetes-seclabs/binary-drift-detection.md"
Write-Host "  Kubernetes-seclabs/dns-detection.md"
