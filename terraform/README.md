# 🏛️ Enterprise Terraform Architecture & Module Catalog

[![Terraform](https://img.shields.io/badge/Terraform-v1.5%2B-7B42BC?style=flat&logo=terraform)](https://www.terraform.io)
[![Azure CAF](https://img.shields.io/badge/Architecture-Azure_CAF_Aligned-0078D4?style=flat&logo=microsoftazure)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/)
[![Security](https://img.shields.io/badge/Security-Zero_Trust-10B981?style=flat&logo=shield)](https://github.com/avinashkean-cpu)

Enterprise-grade Infrastructure as Code (IaC) repository engineered for Microsoft Azure Cloud Adoption Framework (CAF) Landing Zones.

---

## 📦 Modular Architecture

| Module | Purpose | Key Azure Resources |
| :--- | :--- | :--- |
| **[`modules/networking`](./modules/networking)** | Hub-and-Spoke Topology, Edge Security & Routing | Hub VNet, Azure Firewall Premium (IDPS/TLS), Bastion, UDR |
| **[`modules/governance-policy`](./modules/governance-policy)** | Policy Guardrails & Tagging Compliance | Custom Azure Policy Initiatives, TLS 1.2+ Enforce, Geo-Fencing |
| **[`modules/security-identity`](./modules/security-identity)** | Zero-Trust Secrets & Threat Intelligence | Hardened Key Vault (Private Endpoint only), Defender for Cloud |
| **[`modules/enterprise-aks`](./modules/enterprise-aks)** | Production Container Orchestration | Private AKS (Zero-Public-IP), Azure CNI Overlay, Workload Identity |

---

## 🛡️ Best Practices & Quality Standards
- **Trunk-Based GitOps:** Every pull request requires automated `terraform fmt -check`, `tflint`, and `tfsec` scans.
- **State Security:** Geo-redundant Azure Blob storage with lease-based locking and Customer-Managed Keys (CMK).
- **Infracost Integration:** Pre-apply financial cost breakdown commented automatically on PRs.

