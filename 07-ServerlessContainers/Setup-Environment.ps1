###---------------------------------------------------------------------------------
### Bootstraps an Azure environment to test Defender CSPM's discovery and posture
### coverage for SERVERLESS container workloads (GA July 2026): Azure Container Apps
### and Azure Container Instances. This is agentless - Defender CSPM (already Standard
### on this subscription) picks these resources up automatically, nothing to install.
###---------------------------------------------------------------------------------

param(
    [Parameter(Mandatory = $true)][string]$SubscriptionId,
    [string]$Location = "westeurope",
    [string]$ResourceGroup = "rg-defender-serverless-lab",
    [string]$ContainerAppEnvName = "cae-defender-serverless-lab",
    [string]$ContainerAppName = "ca-defender-serverless-demo",
    [string]$ContainerInstanceName = "aci-defender-serverless-demo"
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
Invoke-Az "az extension add --name containerapp --upgrade --yes"
Invoke-Az "az provider register --namespace Microsoft.App --wait"
Invoke-Az "az provider register --namespace Microsoft.OperationalInsights --wait"

# 1 - Resource group
Invoke-Az "az group create --name $ResourceGroup --location $Location"

# 2 - Container Apps environment + a Container App with public ingress enabled
# (intentionally internet-exposed, so the attack path / posture labs have something to find).
Invoke-Az "az containerapp env create --name $ContainerAppEnvName --resource-group $ResourceGroup --location $Location"
Invoke-Az "az containerapp create --name $ContainerAppName --resource-group $ResourceGroup --environment $ContainerAppEnvName --image mcr.microsoft.com/k8se/quickstart:latest --target-port 80 --ingress external --min-replicas 1"

# 3 - A standalone Azure Container Instance (also covered by serverless posture/discovery)
Invoke-Az "az container create --name $ContainerInstanceName --resource-group $ResourceGroup --image mcr.microsoft.com/azuredocs/aci-helloworld:latest --ports 80 --ip-address Public --os-type Linux --cpu 1 --memory 1 --location $Location"

Write-Host "Serverless containers environment ready."
Write-Host "Resource Group      : $ResourceGroup"
Write-Host "Container App       : $ContainerAppName (public ingress)"
Write-Host "Container Instance  : $ContainerInstanceName (public IP)"
Write-Host "Next: follow README.md - discovery/posture findings can take a few hours to appear."
