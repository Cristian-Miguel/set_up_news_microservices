# 🛠️ Enterprise Multi-Repo Orchestrator | Distributed News Platform

This repository serves as the **DevOps and infrastructure core** for the Distributed News Platform. It automates environment provisioning, manages centralized property bindings, secures inter-service traffic via mTLS, and spins up a fully monitored infrastructure using Docker containerization.

---

## 🔗 Connected Microservice Repositories

The system follows an asynchronous, decoupled multi-repo setup applying **Hexagonal Architecture** and Domain-Driven Design (DDD) boundaries:

*   **Config Service:** [news_config_service](https://github.com/Cristian-Miguel/news_config_service) — Git-backed centralized configuration manager (Spring Cloud Config Server).
*   **Discovery Service:** [news_discovery_service](https://github.com/Cristian-Miguel/news_discovery_service) — Service registry leveraging Netflix Eureka.
*   **API Gateway:** [news_api_gateway](https://github.com/Cristian-Miguel/news_api_gateway) — Edge routing service providing unified entry points and secure token validation.
*   **Authentication Service:** [news_auth_service](https://github.com/Cristian-Miguel/news_auth_service) — High-performance security token engine integrated with Redis.
*   **User Service *(WIP)*:** [news_user_service](https://github.com/Cristian-Miguel/news_user_service) — Profile management layer operating under its own database context.

---

## 🏗️ Architecture & Security Features

This infrastructure setup goes beyond local testing and replicates real production standards:

*   **Secured Event Broker:** **Apache Kafka** runs in modern **KRaft mode** (no Zookeeper overhead) and enforces **mTLS/SSL Encryption** for all inter-service communication via pre-generated Java Keystores/Truststores (`.jks`).
*   **Container Security:** Implements **Docker Secrets** to securely provision the **Redis** access keys without exposing raw plaintext passwords in environment variables.
*   **Deterministic Startup Orchestration:** Services leverage strict container **Healthchecks** (`curl` and `redis-cli` network probes) alongside conditional dependencies (`service_healthy` gates) to ensure backing components are fully responsive before booting dependent applications.
*   **Centralized Topology Management:** A multi-layered `.env` ecosystem binds cross-functional tokens (JWT secrets, cryptographic salts)[cite: 4] and custom network bindings (`jdbc:mysql://` clusters)[cite: 4] out of the box.

---

## 🚀 Fully Automated Quick Start

The complete provisioning pipeline is encapsulated within custom automated Shell scripts.

### 1. Configure the Environment
Duplicate the `example.env` template, change the name to `.env` and set your infrastructure values, application ports, JWT token parameters, and database schemas. Ensure the required network ports do not conflict with host machine bindings.

### 2. Run the Automator
Grant execution permissions and kickstart the full environment generation pipeline:

```bash
chmod +x setup_project.sh
./setup_project.sh
