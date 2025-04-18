#!/bin/bash
# test-dashboard.sh
# Note: This script is designed to be run in a github codespace environment.
HOST="https://urban-space-adventure-9gvwj69w9v5c756w-9090.app.github.dev/"
echo "===== 开始 IT 仪表板测试 ====="
echo "$(date)"

echo -e "\n1. 检查容器状态"
docker-compose ps

echo -e "\n2. 测试服务健康状态"
echo "Prometheus: $(curl -s -o /dev/null -w '%{http_code}' ${HOST}:9090/-/healthy)"
echo "Grafana: $(curl -s -o /dev/null -w '%{http_code}' ${HOST}:3000/api/health)"
echo "AlertManager: $(curl -s -o /dev/null -w '%{http_code}' ${HOST}:9093/-/healthy)"
echo "Node Exporter: $(curl -s -o /dev/null -w '%{http_code}' ${HOST}:9100/metrics)"

echo -e "\n3. 验证 Prometheus 目标"
curl -s ${HOST}:9090/api/v1/targets | jq '.data.activeTargets[] | {name: .labels.job, status: .health, last_error: .lastError}'

echo -e "\n4. 测试基本指标查询"
curl -s "${HOST}:9090/api/v1/query?query=up" | jq '.data.result[] | {job: .metric.job, value: .value[1]}'

echo -e "\n5. 测试警报状态"
curl -s ${HOST}:9090/api/v1/alerts | jq '.data.alerts[] | {name: .labels.alertname, state: .state}'

echo -e "\n6. 测试 NGINX 反向代理"
echo "Grafana via NGINX: $(curl -s -o /dev/null -w '%{http_code}' ${HOST}:8080/grafana/)"
echo "Prometheus via NGINX: $(curl -s -o /dev/null -w '%{http_code}' ${HOST}:8080/prometheus/)"

echo -e "\n===== 测试完成 ====="