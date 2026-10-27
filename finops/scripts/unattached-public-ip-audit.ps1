<#
.SYNOPSIS
    Scans Azure Subscriptions for unattached public IP addresses and calculates potential annual savings.
.DESCRIPTION
    Unattached static public IPs incur continuous charges without delivering value.
    This script audits all orphaned IPs and generates an actionable cleanup report.
.AUTHOR
    Avinash Mishra (Principal Cloud & DevSecOps Enterprise Architect)
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $false)]
    [switch]$AutoPurge = $false
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Enterprise FinOps: Orphaned Public IP Audit Engine     " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if ($SubscriptionId) {
    Select-AzSubscription -SubscriptionId $SubscriptionId | Out-Null
}

$orphanedIps = Get-AzPublicIpAddress | Where-Object { $null -eq $_.IpConfiguration -and $null -eq $_.NatGateway }

$totalMonthlyWaste = 0.0
$hourlyCostPerIp = 0.005 # Approx $3.65/month per unused standard public IP
$monthlyCostPerIp = $hourlyCostPerIp * 730

$report = @()

foreach ($ip in $orphanedIps) {
    $totalMonthlyWaste += $monthlyCostPerIp
    $report += [PSCustomObject]@{
        ResourceGroup = $ip.ResourceGroupName
        IPName        = $ip.Name
        Location      = $ip.Location
        IPAddress     = $ip.IpAddress
        MonthlyWaste  = "$([math]::Round($monthlyCostPerIp, 2)) USD"
    }

    if ($AutoPurge) {
        Write-Warning "Purging unattached IP: $($ip.Name) in $($ip.ResourceGroupName)"
        Remove-AzPublicIpAddress -ResourceGroupName $ip.ResourceGroupName -Name $ip.Name -Force
    }
}

$report | Format-Table -AutoSize
Write-Host "Audited Orphaned IPs: $($orphanedIps.Count)" -ForegroundColor Yellow
Write-Host "Projected Annual FinOps Savings: $([math]::Round($totalMonthlyWaste * 12, 2)) USD" -ForegroundColor Green

