#!/bin/bash
set -e

echo "=== 拉取官方最新代码 ==="
git fetch upstream
git merge upstream/main --no-edit

echo "=== 应用自定义补丁 ==="
git apply patches/terms-privacy-links.patch

echo "=== 重新build镜像 ==="
HTTPS_PROXY=http://127.0.0.1:7897 HTTP_PROXY=http://127.0.0.1:7897 \
docker buildx build --platform linux/amd64 \
  -f Dockerfile.dev \
  -t zhazhahuiyuxiaoxiao/postiz:latest \
  --push .

echo "=== 完成！去服务器运行以下命令更新 ==="
echo "cd /opt/postiz && docker compose pull postiz && docker compose up -d --force-recreate postiz"
