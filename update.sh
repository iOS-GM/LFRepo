#!/bin/bash

# ---------- 配置部分 ----------
REPO_DIR="/var/mobile/Documents/LFRepo"  # 仓库绝对路径
GIT_BRANCH="main"                       # 默认分支（根据仓库调整）
# ----------------------------

# 进入仓库目录（失败则退出）
cd "$REPO_DIR" || { echo "错误：无法进入目录 $REPO_DIR"; exit 1; }

# 生成Debian软件包索引（如果debs目录存在）
if [ -d "debs" ]; then
    echo "生成软件包索引..."
    dpkg-scanpackages -m debs /dev/null > Packages
    gzip -c Packages > Packages.gz

    # 计算校验值
    md5_pkg=$(md5sum Packages | cut -d' ' -f1)
    size_pkg=$(wc -c < Packages)
    md5_gz=$(md5sum Packages.gz | cut -d' ' -f1)
    size_gz=$(wc -c < Packages.gz)
    echo "索引已更新 (Packages: $md5_pkg, Packages.gz: $md5_gz)"
fi

# Git操作
echo "提交更新到GitHub..."
git add .
git commit -m "Auto-update: $(date +'%Y-%m-%d %H:%M')"
git pull --rebase origin "$GIT_BRANCH"
git push origin "$GIT_BRANCH"

echo "更新完成！"