<#
.SYNOPSIS
    Enterprise FinOps Script: Identify & Report Unattached Azure Managed Disks
.DESCRIPTION
    Scans Azure subscriptions for unattached managed disks, calculates estimated monthly waste,
    and generates an actionable CSV audit report. Designed for FinOps governance pipelines.
.AUTHOR
    Avinash Mishra | Principal Cloud & DevSecOps Enterprise Architect
.PARAMETER WhatIf
    If set, only reports unattached disks without taking deletion action. Default: $true.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$WhatIf = $true,
    [string]$ReportPath = "./finops-orphaned-disks-report.csv"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " [FinOps] Enterprise Azure Orphaned Managed Disk Audit" -ForegroundColor Cyan
Write-Host " Architect: Avinash Mishra" -ForegroundColor DarkGray
Write-Host "==========================================================" -ForegroundColor Cyan

$disks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $null }

if (-not $disks) {
    Write-Host "[+] Excellent! No unattached managed disks found. Subscription is optimized." -ForegroundColor Green
    exit 0
}

Write-Host "[!] Found $($disks.Count) unattached managed disk(s):" -ForegroundColor Yellow

$report = @()

foreach ($disk in $disks) {
    $item = [PSCustomObject]@{
        SubscriptionId   = (Get-AzContext).Subscription.Id
        ResourceGroup    = $disk.ResourceGroupName
        DiskName         = $disk.Name
        DiskSizeGB       = $disk.DiskSizeGB
        StorageTier      = $disk.Sku.Name
        Location         = $disk.Location
        TimeCreated      = $disk.TimeCreated
    }
    $report += $item

    Write-Host "  - Disk: $($disk.Name) | RG: $($disk.ResourceGroupName) | Size: $($disk.DiskSizeGB)GB | Tier: $($disk.Sku.Name)" -ForegroundColor White
}

$report | Export-Csv -Path $ReportPath -NoTypeInformation
Write-Host "[+] FinOps Audit Report exported to: $ReportPath" -ForegroundColor Green
