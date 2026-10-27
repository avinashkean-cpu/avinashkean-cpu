# 🏛️ Architecture Contribution Guidelines

Welcome to the **Enterprise Cloud & DevSecOps Architecture Center of Excellence (CCoE)** repository.

## 🎯 Architectural Principles
All contributions, blueprints, and automation scripts in this repository adhere to the following principles:
1. **Cloud Adoption Framework (CAF) First:** Every architecture pattern must align to enterprise Landing Zone hierarchy, subscription boundaries, and Zero-Trust principles.
2. **Infrastructure as Code (IaC) Immutability:** No manual portal click-ops. Everything must be codified, parameterized, and tested.
3. **Shift-Left Security & FinOps:** Security guardrails (CIS benchmarks, Least Privilege) and cost estimation (`infracost`) are required on every PR.
4. **Resilience & BCDR:** Architect for failure. Multi-zone, multi-region failover, and strict RTO/RPO targets must be documented.

## 🤝 Submitting Proposals
1. Fork this repository.
2. Create a short-lived branch (`feat/blueprint-title`).
3. Follow the markdown blueprint template.
4. Open a Pull Request with complete architectural justification and risk analysis.
