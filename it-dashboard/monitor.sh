#!/bin/bash
# monitor.sh - 替代 crontab 的监控脚本

while true; do
  ./maintenance.sh
  sleep 300  # 每5分钟执行一次
done