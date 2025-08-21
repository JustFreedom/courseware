#!/usr/bin/env bash
set -euo pipefail

# 仅上传文件，不修改 Nginx 配置（按你要求）
# 本地 miss/ → 服务器 /data/www/course（宿主机路径，容器内映射为 /var/www/course）

# Config
REMOTE="root@120.79.52.176"                         # 服务器账号@IP
REMOTE_DIR_ROOT="/data/www/course"                  # 宿主机课程根目录（首页 index.html）
REMOTE_DIR_JUNIOR="/data/www/course/english/junior" # 初中目录
REMOTE_DIR_SENIOR="/data/www/course/english/senior" # 高中目录（预留）
LOCAL_DIR_ROOT="/Users/taiyi/Desktop/company/sweetdata/miss/"               # 本地根目录（含 index.html）
LOCAL_DIR_JUNIOR="/Users/taiyi/Desktop/company/sweetdata/miss/english/junior/"  # 本地初中目录

# Preflight checks
command -v rsync >/dev/null 2>&1 || { echo "[错误] 未找到 rsync，请先安装 (macOS: brew install rsync)"; exit 1; }
command -v ssh >/dev/null 2>&1 || { echo "[错误] 未找到 ssh"; exit 1; }

# 1) 创建远程目录结构
echo "[1/3] 确认远程目录结构"
ssh "${REMOTE}" "mkdir -p '${REMOTE_DIR_ROOT}' '${REMOTE_DIR_JUNIOR}' '${REMOTE_DIR_SENIOR}'"

# 2) 同步根目录（包含 index.html）
echo "[2/3] 同步根目录到 ${REMOTE_DIR_ROOT}"
rsync -avz --progress --delete \
  --exclude ".DS_Store" \
  --exclude "english/senior/" \
  "${LOCAL_DIR_ROOT}" "${REMOTE}:${REMOTE_DIR_ROOT}"

# 3) 单独确保初中子目录同步（避免根排除影响）
echo "[3/3] 同步初中课程到 ${REMOTE_DIR_JUNIOR}"
rsync -avz --progress --delete \
  --exclude ".DS_Store" \
  "${LOCAL_DIR_JUNIOR}" "${REMOTE}:${REMOTE_DIR_JUNIOR}"

cat <<DONE
上传完成（仅文件同步，未改 Nginx）。
- 宿主机根目录: ${REMOTE_DIR_ROOT}（首页 index.html）
- 初中目录: ${REMOTE_DIR_JUNIOR}
- 高中目录: ${REMOTE_DIR_SENIOR}

提示：
- 你的 docker-compose 已挂载 /data/www/course -> 容器 /var/www/course:ro
- Nginx 站点应在容器内使用 root /var/www/course; index index.html;
- 修改 compose 后请执行：docker compose up -d nginx
- 校验容器内可见：docker exec my-nginx ls -la /var/www/course/index.html
DONE
