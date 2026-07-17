# 🛠️ Multi-Repo Orchestration & Ecosystem Setup | Distributed News Platform

This repository serves as the **central DevOps and infrastructure orchestrator** for the entire Distributed News Platform ecosystem. It contains the core environment configurations, Docker orchestration files, and automation scripts required to clone, configure, and launch the multi-repo architecture seamlessly.

---

## 🔗 Ecosystem Architecture & Linked Repositories

The ecosystem follows a highly decoupled, multi-repo strategy applying **Hexagonal Architecture** and enterprise-level microservice patterns:

*   **Config Service:** [news_config_service](https://github.com/Cristian-Miguel/news_config_service) — Centralized configuration management (Spring Cloud Config) powered by a Git backend.
*   **Discovery Service:** [news_discovery_service](https://github.com/Cristian-Miguel/news_discovery_service) — Service registry and discovery engine.
*   **API Gateway:** [news_api_gateway](https://github.com/Cristian-Miguel/news_api_gateway) — Unified entry point routing, security, and load balancing.
*   **Authentication Service:** [news_auth_service](https://github.com/Cristian-Miguel/news_auth_service) — Core security module handling user access and session tokens (Redis integrated).
*   **User Service *(WIP)*:** [news_user_service](https://github.com/Cristian-Miguel/news_user_service) — Domain service managing user profiles and relational data.

---

## ⚙️ Prerequisites & Environment Configuration

Before initializing the platform, ensure that the required ports are free on your local machine and set up your environment variables.

1.  **Port Availability:** Verify that standard microservice ports (e.g., `8888` for Config, `8761` for Eureka, `8080` for Gateway) and infrastructure ports (Kafka, Redis, Prometheus) are not being used by other local services.
2.  **Configure Environment Variables:** 
    *   Locate the root `.env` file template.
    *   Fill in your custom database credentials, secret keys, Kafka broker locations, and specific service properties. The configuration data is structured per microservice for granular control.

---

## 🚀 Automated Deployment & Quick Start

The entire ecosystem setup has been fully automated using custom Bash utility scripts. The automation script handles repository cloning, configuration binding, and local container orchestration.

### 1. Grant execution permissions to the setup script:
```bash
chmod +x setup_project.sh
