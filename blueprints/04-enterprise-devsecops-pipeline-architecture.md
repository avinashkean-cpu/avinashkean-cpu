# 🛡️ Enterprise DevSecOps Pipeline & GitOps Architecture

> **Author:** Avinash Mishra | Principal Cloud & DevSecOps Enterprise Architect  
> **CI/CD Platforms:** Azure DevOps Pipelines & GitHub Actions  
> **Infrastructure as Code:** Terraform Enterprise (Remote State, Drift Detection, Shift-Left Security)  

---

## 1. DevSecOps Philosophy & Trunk-Based GitOps

Enterprise software delivery requires continuous integration, immutable infrastructure deployments, and shift-left security embedded directly into developers' everyday git workflows.

```
Feature Branch (Short-Lived < 24h)
        │
        ├── 🔹 Lint & Format (terraform fmt, tflint)
        ├── 🔹 Static Security Analysis (checkov, tfsec)
        ├── 🔹 Secret Scanning (gitleaks, trufflehog)
        ├── 🔹 Cost Delta Preview (infracost)
        └── 🔹 Mandatory Pull Request Review (2+ Approvers & CODEOWNERS)
        │
Merge to Main (Trunk-Based)
        │
        ├── 🔹 Stage: Build & Package Artifacts
        ├── 🔹 Stage: Terraform Plan (Artifact Saved)
        ├── 🔹 Stage: Manual Environment Approval Gate
        ├── 🔹 Stage: Terraform Apply (Production Deployment)
        └── 🔹 Stage: Post-Deployment Smoke Tests & Rollback Trigger
```

---

## 2. Terraform Enterprise Architecture Best Practices

### 2.1 Remote State Security & Concurrency
- **Storage:** Dedicated Azure Storage Account isolated inside the Platform Management subscription.
- **Access Controls:** Strictly managed via Azure RBAC with no shared storage account keys; access granted exclusively to Azure DevOps service principals via Managed Identities / OIDC.
- **State Locking:** Native blob lease locking preventing concurrent execution collisions.
- **Data Protection:** Customer-Managed Keys (CMK) encryption-at-rest via Azure Key Vault with purge protection enabled.
- **Versioning & Soft Delete:** Blob versioning enabled on state containers to allow instantaneous recovery from corrupted states.

### 2.2 Modular Architecture Standards
- Modular, version-pinned modules hosted in internal registries or dedicated repositories:
  - `terraform-azure-vnet-hub-spoke`
  - `terraform-azure-firewall`
  - `terraform-azure-aks-cluster`
  - `terraform-azure-linux-vm`
  - `terraform-azure-sql-database`
- Strict separation between **Modules** (generic, reusable definitions) and **Environments** (`environments/dev`, `environments/uat`, `environments/prod` calling modules with distinct variables).

---

## 3. Branching Governance & Code Protection Policies

- **Trunk-Based Development:** Long-lived feature branches are banned. Developers work on short-lived branches merged into `main` daily.
- **Branch Protection Rules on `main`:**
  - Direct pushes and branch deletions are strictly disabled (`No-Delete`).
  - Mandatory minimum of **2 peer code reviews** before PR merge.
  - Required sign-off from designated **CODEOWNERS** for core infrastructure folders.
  - All CI status checks (linting, testing, security scans) must pass before merge button unlocks.
  - Commit history squashed to maintain clean, bisectable git logs.

---

## 4. Automated Daily Drift Detection Pipeline

Cloud drift occurs when team members introduce manual changes in the Azure portal out-of-band:
1. Scheduled cron pipeline triggers daily at 02:00 AM UTC.
2. Runs `terraform plan -detailed-exitcode`.
3. If exit code is `2` (drift detected between state file and actual Azure cloud state):
   - Pipeline generates a diff summary highlighting unmanaged changes.
   - Automatically posts an alert to the Cloud Platform Engineering Teams/Slack channel and raises a Jira defect for remediation.
