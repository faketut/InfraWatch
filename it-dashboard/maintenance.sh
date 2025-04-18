#!/bin/bash

# 定义日志文件
LOG_FILE="/workspaces/InfraWatch/it-dashboard/it-dashboard-maintenance.log"

# 日志函数
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 检查Docker服务
# 修改 Docker 服务检查部分
check_docker() {
  log "Checking Docker service status..."
  if ! docker info &>/dev/null; then
    log "Docker service is not responding. In Codespace environment, manual restart may be required."
    # 在 Codespace 中无法使用 systemctl
    # 可以尝试其他方式，或者只记录日志
  else
    log "Docker service is running."
  fi
}

# 检查容器健康状态
check_containers() {
    log "Checking container status..."
    CONTAINERS=("prometheus" "grafana" "node-exporter" "alertmanager" "nginx")
    
    for container in "${CONTAINERS[@]}"; do
        if ! docker ps -q --filter "name=$container" | grep -q .; then
            log "Container $container is down. Attempting to restart..."
            cd /workspaces/InfraWatch/it-dashboard && docker-compose up -d $container
            sleep 5
            if docker ps -q --filter "name=$container" | grep -q .; then
                log "Container $container restarted successfully."
            else
                log "Failed to restart container $container. Manual intervention required."
                # 发送通知
                #echo "Failed to restart $container on $(hostname)" | mail -s "ALERT: Container Down" admin@example.com
            fi
        else
            log "Container $container is running."
        fi
    done
}

# 日志旋转
rotate_logs() {
    log "Rotating logs..."
    if [ -f "$LOG_FILE" ] && [ $(du -k "$LOG_FILE" | cut -f1) -gt 5120 ]; then
        # 如果日志大于5MB，进行旋转
        timestamp=$(date +%Y%m%d%H%M%S)
        mv "$LOG_FILE" "${LOG_FILE}.${timestamp}"
        gzip "${LOG_FILE}.${timestamp}"
        touch "$LOG_FILE"
        log "Log rotation completed."
    else
        log "Log file size is under threshold, no rotation needed."
    fi
    
    # 保留最近10个日志文件
    ls -t "${LOG_FILE}".* 2>/dev/null | tail -n +11 | xargs -I {} rm {} 2>/dev/null
}

# 备份数据
backup_data() {
  log "Starting backup process..."
  BACKUP_DIR="$HOME/workspace/backups"
  mkdir -p $BACKUP_DIR
  
  # 备份名称包含日期
  BACKUP_DATE=$(date +%Y%m%d)
  BACKUP_NAME="it-dashboard-backup-${BACKUP_DATE}.tar.gz"
  
  # 在 Codespace 中，不需要停止容器，可以直接备份配置文件
  tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" -C $HOME/workspace/your-repo-name/it-dashboard .
  
  log "Backup completed: ${BACKUP_DIR}/${BACKUP_NAME}"
  
  # 只保留最近 3 个备份以节省空间
  ls -t $BACKUP_DIR/it-dashboard-backup-*.tar.gz | tail -n +4 | xargs -I {} rm {} 2>/dev/null
}

# 执行所有维护任务
main() {
    log "Starting maintenance tasks..."
    check_docker
    check_containers
    rotate_logs
    backup_data
    log "Maintenance tasks completed."
}

# 运行主函数
main
