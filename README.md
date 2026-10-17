# Multi-Container DevOps Infrastructure & Automation Project

A robust, production-grade multi-container environment built with Docker, NGINX, Flask, PostgreSQL, and Redis. Features automated CI/CD pipelines, log processing, backup/restore mechanisms, and live failover resilience.

---

## 🏗️ Architecture Overview

The system simulates a high-availability microservices architecture with isolated network layers:

- **NGINX**: Reverse Proxy & Load Balancer routing traffic to application instances.
- **Application Layer**: Scalable Flask API containers (`app-01`, `app-02`).
- **Database Layer**: PostgreSQL with persistent volume storage for transactional data.
- **Cache Layer**: Redis in-memory cache for session management and quick data access.
- **Networks**: Isolated `frontend` and `backend` networks to enforce strict security principles.

---

## 🛠️ Key Features & Troubleshooting Highlights

- **Log Correlation & Metrics**: Analyzed production logs (`access.log`, `error.log`, `application.log`) linked by `request_id` to trace backend failures, calculating latency percentiles (P95) and error rates.
- **Infrastructure Fixes**: Resolved real-world configuration bugs, including port mismatches, network binding restrictions, and credential management.
- **CI/CD Automation**: Integrated **GitHub Actions** (`.github/workflows/ci.yml`) to automatically validate configurations, run test suites, and ensure zero-downtime builds.
- **Data Persistence & Recovery**: Automated database and cache snapshots via `backup.sh` and `restore.sh` shell scripts.

---

## 🚀 Quick Start

### Prerequisites
- Linux / WSL2
- Docker & Docker Compose
- Python 3.12+

### Setup & Deployment

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/samehsamy12/multi-container-devops-project.git](https://github.com/samehsamy12/multi-container-devops-project.git)
   cd multi-container-devops-project
