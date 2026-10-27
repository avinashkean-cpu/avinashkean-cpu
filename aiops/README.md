# 🤖 Enterprise AIOps & Predictive Observability Architecture

[![AIOps](https://img.shields.io/badge/AIOps-Predictive_Remediation-00D2FF?style=flat&logo=openai)](https://github.com/avinashkean-cpu)
[![KQL](https://img.shields.io/badge/Observability-KQL_Time_Series-7C3AED?style=flat)](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/)
[![SRE](https://img.shields.io/badge/SRE-Self_Healing_Runbooks-10B981?style=flat)](https://github.com/avinashkean-cpu)

Enterprise AIOps framework designed to transition operations from reactive firefighting to predictive, self-healing cloud resilience.

---

## 🏗️ Architectural Flow

```
[ Telemetry Ingestion ] ──> [ Machine Learning Analytics ] ──> [ Automated Self-Healing ]
  • Log Analytics             • series_decompose_anomalies       • Azure Automation Runbook
  • Application Insights      • Z-Score Statistical Variance     • Zero-Downtime Slot Swap
  • Azure Sentinel SIEM       • Dynamic Threshold Triggering     • PagerDuty Smart Alerting
```

---

## 📁 Artifacts & Source Code

| Artifact | Language | Purpose |
| :--- | :--- | :--- |
| **[`detectors/kql-anomaly-queries.kql`](./detectors/kql-anomaly-queries.kql)** | KQL | Production time-series anomaly detection for CPU, 5xx errors, and AKS CrashLoops. |
| **[`detectors/telemetry-incident-analyzer.py`](./detectors/telemetry-incident-analyzer.py)** | Python | Z-Score statistical anomaly engine with webhook dispatch logic. |
| **[`runbooks/auto-remediate-crashloop.ps1`](./runbooks/auto-remediate-crashloop.ps1)** | PowerShell | Azure Managed Identity runbook that self-heals failing services automatically. |

---

## 🎯 Strategic ROI
- **70% Reduction in Mean Time to Detect (MTTD)** via predictive statistical baselining.
- **50%+ Reduction in Mean Time to Remediate (MTTR)** through automated zero-touch runbooks.
- **Elimination of Alert Fatigue** by replacing static thresholds with dynamic ML variance detection.

