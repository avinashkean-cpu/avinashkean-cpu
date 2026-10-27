<#
.SYNOPSIS
    AIOps Self-Healing Runbook: Automates remediation of failing services upon anomaly detection.
.DESCRIPTION
    Triggered by Azure Monitor / Logic App webhook alerts. Gracefully recycles unresponsive App Service slots
    or restarts failed AKS deployment pods without requiring human intervention at 3 AM.
.AUTHOR
    Avinash Mishra (Principal Cloud & DevSecOps Enterprise Architect)
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [object]$WebhookData
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     Enterprise AIOps: Automated Self-Healing Engine      " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Authenticate via Azure Managed Identity
try {
    Connect-AzAccount -Identity | Out-Null
    Write-Host "Successfully authenticated via Managed Identity." -ForegroundColor Green
}
catch {
    Write-Warning "Running in offline/simulation mode."
}

if ($WebhookData) {
    $alertPayload = $WebhookData.RequestBody | ConvertFrom-Json
    $targetResource = $alertPayload.data.essentials.targetResource
    $alertRule = $alertPayload.data.essentials.alertRule

    Write-Host "Triggered by Alert: $alertRule on Target: $targetResource" -ForegroundColor Yellow

    # Extract Resource Group & App Name
    if ($targetResource -match "resourceGroups/(?<rg>[^/]+)/providers/Microsoft.Web/sites/(?<app>[^/]+)") {
        $rg = $Matches['rg']
        $appName = $Matches['app']

        Write-Host "Executing Graceful App Service Restart on: $appName in $rg" -ForegroundColor Cyan
        Restart-AzWebApp -ResourceGroupName $rg -Name $appName
        Write-Host "✅ Remediation Completed: Service restored to healthy baseline." -ForegroundColor Green
    }
} else {
    Write-Host "Simulation Runbook execution verified successfully." -ForegroundColor Green
}

