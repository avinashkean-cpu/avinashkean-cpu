<#
.SYNOPSIS
    Automated Azure Non-Production Virtual Machine Scheduler
.DESCRIPTION
    Starts or stops Azure Virtual Machines tagged with 'AutoSchedule = true'
    to eliminate off-hours compute costs, saving up to ~70% on Dev/UAT spend.
.AUTHOR
    Avinash Mishra | Principal Cloud & DevSecOps Enterprise Architect
.PARAMETER Action
    Accepts 'Start' or 'Stop'.
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Start", "Stop")]
    [string]$Action,

    [string]$TagName = "AutoSchedule",
    [string]$TagValue = "true"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " [FinOps] Enterprise VM Auto-$Action Scheduler" -ForegroundColor Cyan
Write-Host " Architect: Avinash Mishra" -ForegroundColor DarkGray
Write-Host "==========================================================" -ForegroundColor Cyan

$vms = Get-AzVM -Status | Where-Object { $_.Tags[$TagName] -eq $TagValue }

if (-not $vms) {
    Write-Host "[!] No Virtual Machines found with tag '$TagName = $TagValue'." -ForegroundColor Yellow
    exit 0
}

foreach ($vm in $vms) {
    $powerState = ($vm.Statuses | Where-Object Code -like "PowerState*").DisplayStatus

    if ($Action -eq "Stop" -and $powerState -eq "VM running") {
        Write-Host "[-] Deallocating VM: $($vm.Name) in RG: $($vm.ResourceGroupName)..." -ForegroundColor Yellow
        Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait
    }
    elseif ($Action -eq "Start" -and $powerState -ne "VM running") {
        Write-Host "[+] Starting VM: $($vm.Name) in RG: $($vm.ResourceGroupName)..." -ForegroundColor Green
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -NoWait
    }
    else {
        Write-Host "[i] Skipping VM: $($vm.Name) (Current State: $powerState)" -ForegroundColor DarkGray
    }
}

Write-Host "[+] Auto-$Action operation initiated across $($vms.Count) VM(s)." -ForegroundColor Green
