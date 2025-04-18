#!/bin/bash
# codespace-startup.sh

# 设置工作目录
WORKSPACE="$HOME/workspace/$(basename $(pwd))"
DASHBOARD_DIR="$WORKSPACE/it-dashboard"

# 确保目录存在
mkdir -p $DASHBOARD_DIR

# 复制配置文件（如果需要）
# cp -r config/* $DASHBOARD_DIR/

# 启动服务
cd $DASHBOARD_DIR
docker-compose up -d

# 显示访问信息
echo "=========================================="
echo "服务已启动，可通过以下URL访问："
echo "Grafana:      https://$CODESPACE_NAME-3000.preview.app.github.dev"
echo "Prometheus:   https://$CODESPACE_NAME-9090.preview.app.github.dev"
echo "AlertManager: https://$CODESPACE_NAME-9093.preview.app.github.dev"
echo "NGINX:        https://$CODESPACE_NAME-8080.preview.app.github.dev"
echo "=========================================="