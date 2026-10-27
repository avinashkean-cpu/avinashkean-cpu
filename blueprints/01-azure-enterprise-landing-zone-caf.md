# 🏛️ Azure Enterprise Landing Zone (CAF) Reference Architecture

> **Architect:** Avinash Mishra | Principal Cloud & DevSecOps Enterprise Architect  
> **Framework:** Microsoft Cloud Adoption Framework (CAF) for Azure  
> **Topology:** Hub-and-Spoke with Centralized Egress & Zero-Trust Segmentation  

---

## 1. Executive Summary

This architecture blueprint specifies the enterprise-grade **Cloud Adoption Framework (CAF) Landing Zone** design deployed for multi-subscription Azure cloud environments. It provides predictable governance, sovereign subscription boundaries, strict network isolation, and centralized security management capable of scaling to hundreds of enterprise workloads.

---

## 2. Tenant & Management Group Hierarchy

The organization leverages a 4-tier hierarchical Management Group structure rooted beneath the **Microsoft Entra ID Tenant Root Group**:

```
Tenant Root Group (Global Policies: Region Restriction, Tagging Enforcement)
│
├── 📁 Platform Management Group
│   ├── 🔹 Connectivity Subscription (Hub VNet, Azure Firewall, ExpressRoute, VPN, Private DNS)
│   ├── 🔹 Management Subscription (Log Analytics, Azure Monitor, Microsoft Sentinel)
│   └── 🔹 Identity Subscription (Entra Domain Services, Active Directory VMs, Key Vault)
│
├── 📁 Landing Zones Management Group
│   ├── 📁 Corp (Connected via Hub VNet, Private Endpoints, Non-Public Facing)
│   │   ├── 🔹 Production Workload Subscriptions (PCI, ERP, Core Apps)
│   │   └── 🔹 Non-Production Subscriptions (Dev, Test, UAT)
│   └── 📁 Online (Public-facing workloads with Azure Front Door / Application Gateway)
│       └── 🔹 E-Commerce & Customer Portals
│
├── 📁 Sandbox Management Group
│   └── 🔹 Isolated Subscriptions for R&D (Auto-budget caps, detached networking)
│
└── 📁 Decommissioned Management Group
    └── 🔹 Subscriptions pending deletion (Inherits deny-all resource creation policies)
```

---

## 3. Network Architecture: Hub-and-Spoke Topology

### 3.1 Hub Virtual Network (Central Inspection)
- **Centralized Hub VNet:** Acts as the single entry and exit point for all hybrid and internet traffic.
- **Azure Firewall Premium:** 
  - Integrated IDPS (Intrusion Detection and Prevention System).
  - TLS Inspection for deep payload examination.
  - Centralized application and network rule collections.
- **Hybrid Connectivity:** Dual-redundant **ExpressRoute** circuits with active-passive **Azure VPN Gateway** for high-availability backup.
- **Private DNS Zones:** Centralized resolution for PaaS services (`privatelink.database.windows.net`, `privatelink.blob.core.windows.net`, `privatelink.vaultcore.azure.net`).
- **Azure Bastion:** Secure, agentless RDP/SSH access without public IPs.

### 3.2 Spoke Virtual Networks (Workload Isolation)
- **VNet Peering:** High-throughput, low-latency bi-directional peering connecting spokes directly to the Hub VNet.
- **User-Defined Routes (UDR):** 
  - Subnet route tables containing `0.0.0.0/0` next-hop pointing to the Azure Firewall private IP.
  - Spoke-to-spoke traffic force-routed through the Hub Firewall for east-west inspection.
- **Network Security Groups (NSGs) & Application Security Groups (ASGs):** Micro-segmentation enforcing tier-level access controls (Web, App, Data).
- **Private Endpoints:** All Azure PaaS resources (SQL, Storage, Key Vault) exposed exclusively via private IP addresses within spoke subnets.

---

## 4. Enterprise Identity & Zero-Trust Governance

### 4.1 Microsoft Entra ID (Azure AD)
- **Privileged Identity Management (PIM):** Just-in-Time (JIT) role elevation with required approval workflows, time-bound access, and mandatory justification logging.
- **Conditional Access Policies:** Enforced Multi-Factor Authentication (MFA), compliant device requirements, and geographic geofencing.
- **Managed Identities:** System-assigned and user-assigned managed identities used for all service-to-service communication, eliminating stored credentials.

### 4.2 Azure Policy & Initiatives
- **Tagging Governance:** Mandatory tags (`CostCenter`, `Environment`, `Owner`, `ApplicationID`, `Criticality`).
- **Data Residency:** Deployments restricted to approved regions (e.g., Central India, South India / East US, West US).
- **Security Guardrails:** Deny public IP assignment to virtual machine network interfaces; enforce HTTPS-only traffic; require minimum TLS 1.2+ on all PaaS services.
- **Policy Exemptions:** Managed via documented exception registers with designated expiry dates and architectural reviews.

---

## 5. Day-2 Operations & Continuous Validation
- **Terraform Enterprise IaC:** Entire landing zone defined as modular, immutable code in version-controlled repositories.
- **Scheduled Drift Detection:** Nightly automated pipelines verifying Azure infrastructure state against Terraform state.
- **Defender for Cloud:** Continuous CSPM (Cloud Security Posture Management) scoring against CIS Azure Foundations Benchmark.
