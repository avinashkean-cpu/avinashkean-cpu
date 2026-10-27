# 🛡️ Business Continuity, Disaster Recovery (BCDR) & Observability

> **Author:** Avinash Mishra | Principal Cloud & DevSecOps Enterprise Architect  
> **Target Availability:** 99.99% Enterprise Uptime  
> **Recovery Targets:** Tier-1 RTO < 1 Hour, RPO < 15 Minutes  

---

## 1. Storage & Compute Resilience Patterns

### 1.1 Storage Redundancy Selection Matrix

| Redundancy Tier | Data Replication Mechanism | Resiliency Scope | Target Use Case |
| :--- | :--- | :--- | :--- |
| **LRS (Locally Redundant)** | 3 copies synchronously in single datacenter | Datacenter-level disk failure | Non-prod, dev/test, scratch storage |
| **ZRS (Zone-Redundant)** | 3 copies synchronously across 3 Availability Zones | Datacenter / Zone catastrophe | Production file shares, databases, state storage |
| **GRS (Geo-Redundant)** | 3 copies in primary zone + 3 copies async in paired region | Complete regional catastrophe | Critical long-term backups, compliance archives |
| **RA-GRS (Read-Access Geo)** | GRS with read endpoints unlocked in secondary region | Regional read survivability | Global reporting, multi-region read replicas |

### 1.2 Virtual Machine Scale Sets (VMSS)
- Spanned across **3 Azure Availability Zones** (Zone 1, Zone 2, Zone 3) within the primary region.
- Integrated with Azure Load Balancer / Application Gateway health probes for automated instance replacement.
- Horizontal metric-based autoscaling rules (CPU utilization `>75%` triggers scale-out, `<25%` triggers scale-in).

---

## 2. Multi-Region Disaster Recovery Architecture

```
[ Primary Region (e.g., Central India) ]               [ Secondary Region (e.g., South India) ]
┌───────────────────────────────────────┐             ┌────────────────────────────────────────┐
│  • Hub VNet & Azure Firewall          │             │  • Standby Hub VNet & Standby Firewall │
│  • Production AKS & App VMSS          │   ASR/DMS   │  • Cold/Warm Standby Compute Pools     │
│  • Azure SQL Primary (Active Read/Write)═════════════>  • Azure SQL Secondary (Read Replica) │
│  • Storage Accounts (ZRS)             │             │  • Secondary Backup Vault (GRS)        │
└───────────────────────────────────────┘             └────────────────────────────────────────┘
```

- **Azure Site Recovery (ASR):** Continuous block-level replication of application VMs to the paired secondary region.
- **Failover Orchestration:** Pre-scripted Azure Automation / PowerShell runbooks to handle DNS failover via Azure Traffic Manager / Azure Front Door.
- **Quarterly DR Drill Simulations:** Executing non-disruptive test failovers in dedicated sandbox VNets to ensure operational readiness.

---

## 3. Observability & SRE Operations

- **Azure Monitor & Log Analytics:** Centralized workspace collecting metrics, diagnostic logs, and audit trails across all subscriptions.
- **KQL (Kusto Query Language) Dashboards:** Real-time visualization for HTTP 5xx spikes, database query latency, and firewall drop rates.
- **Dynamic Alert Processing Rules:** Incident alerts routed intelligently based on severity (`Sev-0` to `Sev-4`) directly to PagerDuty and incident response bridges.
