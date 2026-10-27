<#
.SYNOPSIS
    Automated Daily Terraform Drift Detection Runner
.DESCRIPTION
    Executes a Terraform plan with detailed exit codes in CI/CD pipelines.
    Detects unauthorized manual portal changes and flags drifts immediately.
.AUTHOR
    Avinash Mishra | Principal Cloud & DevSecOps Enterprise Architect
#>

param(
    [string]$WorkingDirectory = "./terraform",
    [string]$PlanOutputFile = "drift-plan.tfplan"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " [DevSecOps] Terraform Cloud Drift Detection Pipeline" -ForegroundColor Cyan
Write-Host " Architect: Avinash Mishra" -ForegroundColor DarkGray
Write-Host "==========================================================" -ForegroundColor Cyan

Set-Location $WorkingDirectory

Write-Host "[*] Initializing Terraform backend..." -ForegroundColor White
terraform init -input=false

Write-Host "[*] Generating execution plan with -detailed-exitcode..." -ForegroundColor White
terraform plan -detailed-exitcode -out=$PlanOutputFile -input=false

$exitCode = $LASTEXITCODE

switch ($exitCode) {
    0 {
        Write-Host "[+] SUCCESS: No drift detected. Azure infrastructure matches code state." -ForegroundColor Green
        exit 0
    }
    1 {
        Write-Error "[-] ERROR: Terraform plan execution failed."
        exit 1
    }
    2 {
        Write-Warning "[!] ALERT: DRIFT DETECTED! Cloud infrastructure has diverged from Terraform state."
        Write-Host "[*] Printing drift summary:" -ForegroundColor Yellow
        terraform show -no-color $PlanOutputFile
        exit 2
    }
}
