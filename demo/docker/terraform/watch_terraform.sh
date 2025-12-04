#!/bin/bash

# ===============================
# 配置
# ===============================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # 脚本目录
CONFIG_FILE="$SCRIPT_DIR/app/configs.json"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/watch_terraform.log"

# 确保 logs 目录存在
mkdir -p "$LOG_DIR"

# 获取文件初始 hash
if [ ! -f "$CONFIG_FILE" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $CONFIG_FILE 不存在" >> "$LOG_FILE"
    exit 1
fi

LAST_HASH=$(sha256sum "$CONFIG_FILE" | awk '{print $1}')
echo "$(date '+%Y-%m-%d %H:%M:%S') - Watch script started. Initial hash: $LAST_HASH" >> "$LOG_FILE"

# ===============================
# 启动时先执行一次 terraform apply
# ===============================
echo "$(date '+%Y-%m-%d %H:%M:%S') - Initial terraform apply..." >> "$LOG_FILE"
cd "$SCRIPT_DIR" || exit
terraform apply -auto-approve 2>&1 | tee -a "$LOG_FILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Initial terraform apply finished." >> "$LOG_FILE"

# ===============================
# 循环监控
# ===============================
while true; do
    sleep 10  # 每 xx 秒检查一次

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - WARNING: $CONFIG_FILE 不存在" >> "$LOG_FILE"
        continue
    fi

    CURRENT_HASH=$(sha256sum "$CONFIG_FILE" | awk '{print $1}')

    if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Detected change in $CONFIG_FILE. Old hash: $LAST_HASH, New hash: $CURRENT_HASH" >> "$LOG_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Running terraform apply..." >> "$LOG_FILE"

        # 在当前目录执行 terraform apply 并记录完整输出
        cd "$SCRIPT_DIR" || exit
        terraform apply -auto-approve 2>&1 | tee -a "$LOG_FILE"

        echo "$(date '+%Y-%m-%d %H:%M:%S') - terraform apply finished." >> "$LOG_FILE"

        # 更新 hash
        LAST_HASH="$CURRENT_HASH"
    fi
done
