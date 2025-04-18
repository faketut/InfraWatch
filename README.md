# InfraWatch
Real-Time Monitoring Dashboard
部署了实时基础设施监控仪表板，使用 Prometheus + Grafana + Node Exporter，可视化多个虚拟机的指标
通过 Docker Compose 自动化部署；使用 NGINX反向代理 提供安全的、密码保护的远程访问
添加了警报系统，通过Slack/Email钩子通知资源峰值，模拟内部IT警报基础设施
使用 crontab + Bash脚本 进行日志轮换和服务自愈重启，增强系统可靠性
实现了跨多个虚拟机的分布式监控，展示了高级网络配置和集成能力