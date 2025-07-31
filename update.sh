#!/bin/bash

cd /var/mobile/LFRepo

# 生成索引文件
dpkg-scanpackages -m . /dev/null > Packages
gzip -c Packages > Packages.gz

# 计算校验值
md5_pkg=$(md5sum Packages | cut -d' ' -f1)
size_pkg=$(wc -c < Packages)
md5_gz=$(md5sum Packages.gz | cut -d' ' -f1)
size_gz=$(wc -c < Packages.gz)

# 提交更新
git add .
git commit -m "Auto-update $(date +'%Y-%m-%d %H:%M')"
git pull --rebase
git push origin main