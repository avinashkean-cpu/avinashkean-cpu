# 🧠 Enterprise MLOps Architecture & Automated Lifecycle

[![MLOps](https://img.shields.io/badge/MLOps-Azure_ML_v2-0078D4?style=flat&logo=microsoftazure)](https://learn.microsoft.com/en-us/azure/machine-learning/)
[![MLflow](https://img.shields.io/badge/Tracking-MLflow-0194E2?style=flat&logo=mlflow)](https://mlflow.org/)
[![Canary](https://img.shields.io/badge/Deployment-Blue%2FGreen_Canary-10B981?style=flat)](https://github.com/avinashkean-cpu)

Enterprise Machine Learning Operations (MLOps) framework automating training, evaluation, model governance, and zero-downtime canary inference deployments.

---

## 🏗️ End-to-End MLOps Pipeline Flow

```
[ Code & Data Commit ] ──> [ Distributed Training ] ──> [ Model Registry ] ──> [ Canary Rollout ]
  • Git PR Gate               • Auto-scaling GPU/CPU      • Version Tagging          • Managed Online API
  • Data Integrity Checks     • MLflow Metric Logging     • Approval Gate            • 90/10 Traffic Split
```

---

## 📁 Repository Artifacts

| Component | Path | Description |
| :--- | :--- | :--- |
| **Terraform IaC** | **[`terraform/`](./terraform)** | Hardened Azure ML Workspace, Storage (ZRS), Key Vault, ACR, & 0-node idle Compute Cluster. |
| **CI/CD Automation** | **[`pipelines/azure-pipelines-mlops.yml`](./pipelines/azure-pipelines-mlops.yml)** | 4-Stage enterprise pipeline: Quality -> Train -> Registry -> Canary Deploy. |
| **Deployment Config** | **[`pipelines/model_deployment_config.json`](./pipelines/model_deployment_config.json)** | Azure ML Managed Online Endpoint schema with dynamic traffic routing. |

---

## 🎯 Production Engineering Highlights
- **FinOps Scale-to-Zero:** Training cluster dynamically terminates after 15 minutes of idle time.
- **Enterprise Governance:** All scoring container images scanned via Microsoft Defender for Containers.
- **Zero-Downtime Rollouts:** Automated Blue/Green canary deployments eliminate production downtime during model updates.

