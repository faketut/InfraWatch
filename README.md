# InfraWatch

## Real-Time Monitoring Dashboard

InfraWatch is a real-time infrastructure monitoring dashboard that visualizes system metrics across multiple virtual machines using industry-standard tools.

### 🛠️ Features

- **Real-Time Metrics Visualization**  
  Deployed using **Prometheus**, **Grafana**, and **Node Exporter** to monitor CPU, memory, disk I/O, and network usage across multiple VMs.

- **Automated Deployment**  
  Set up with **Docker Compose** for ease of deployment and maintenance.

- **Secure Remote Access**  
  Configured **NGINX reverse proxies** to enable password-protected, encrypted access to the dashboard.

- **Proactive Alerting System**  
  Integrated **Slack** and **Email** hooks to send alerts when system resources exceed defined thresholds—mimicking internal IT alert protocols.

- **Reliability Enhancements**  
  Used **crontab** and **Bash scripts** for scheduled log rotation and automatic service restarts, ensuring continuous uptime and log hygiene.

- **Scalable Multi-VM Monitoring**  
  Supports distributed monitoring across virtualized environments, showcasing advanced network configuration and infrastructure integration.

---

> ⚙️ Designed for IT infrastructure visibility, alerting, and proactive maintenance workflows in modern DevOps/ITOps environments.
