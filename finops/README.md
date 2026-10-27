# 💰 Enterprise FinOps & Cloud Economics Engineering

[![FinOps Foundation](https://img.shields.io/badge/FinOps-Practitioner_Certified-10B981?style=flat&logo=cashapp)](https://www.finops.org/)
[![Infracost](https://img.shields.io/badge/CI%2FCD-Infracost_PR_Gates-00D2FF?style=flat)](https://www.infracost.io/)

Production-grade FinOps automation toolchain engineered to deliver transparency, waste reduction, and proactive cost governance.

---

## 🛠️ Tooling & Automation Artifacts

| Artifact | Type | Description |
| :--- | :--- | :--- |
| **[`scripts/cleanup-orphaned-disks.ps1`](./scripts/cleanup-orphaned-disks.ps1)** | PowerShell Runbook | Scans and deletes unattached managed disks across subscriptions. |
| **[`scripts/auto-start-stop-vms.ps1`](./scripts/auto-start-stop-vms.ps1)** | Azure Automation | Off-hours compute scheduling, saving 65%+ on non-prod VM compute. |
| **[`scripts/unattached-public-ip-audit.ps1`](./scripts/unattached-public-ip-audit.ps1)** | Audit Tool | Detects idle public IPs and computes projected annual waste. |
| **[`infracost/infracost.yml`](./infracost/infracost.yml)** | CI/CD Config | Pull Request shift-left financial impact preview for Terraform. |
| **[`policies/cost-governance-budget.json`](./policies/cost-governance-budget.json)** | Azure Policy/ARM | Automated budget alerts at 80% actual and 100% forecasted spend. |

---

## 📈 Proven Enterprise Impact
- **40%+ Net Cloud Cost Reduction** delivered across multi-tenant enterprise migrations.
- **100% Resource Tagging Attribution** driving transparent business unit chargebacks.
- **Automated PR Financial Gates** preventing unbudgeted infrastructure provisioning.

