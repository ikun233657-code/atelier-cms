# ============================================================
# Dockerfile — Directus CMS for Railway
# 基于官方镜像，添加生产环境优化
# ============================================================

FROM directus/directus:10.13.0

# 切换到 root 安装依赖
USER root

# 安装 Directus 扩展所需工具（可选，按需保留）
RUN corepack enable && \
    apk add --no-cache \
      curl \
      wget \
      tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

# 创建上传目录并设置权限
RUN mkdir -p /directus/uploads && \
    chown -R node:node /directus/uploads

# 切回 node 用户（安全最佳实践）
USER node

# 工作目录
WORKDIR /directus

# Railway 注入 PORT 变量（默认 8055）
# Directus 通过环境变量 PORT 读取端口
ENV PORT=8055
EXPOSE 8055

# 启动：先执行数据库迁移/初始化，再启动服务
# bootstrap = 创建数据库表结构 + 创建管理员账号（幂等操作，可重复执行）
CMD node /directus/cli.js bootstrap && npx directus start
