#!/bin/bash
set -x 
cd openwrt
echo "开始替换 feeds中的rust ..."
echo "========================================"

rm -rf ./feeds/packages/lang/rust
#cp -r patches/rust openwrt/feeds/packages/lang/                   #在github环境下，用下面的语句
cp -f $GITHUB_WORKSPACE/patches/rust ./feeds/packages/lang/rust
#cp -f $GITHUB_WORKSPACE/images/bg.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

echo "===== 查看rust文件是否存在 ====="
ls -l ./feeds/packages/lang/ | grep rust

# 额外验证Makefile是否存在（核心文件）
if [ -f "./feeds/packages/lang/rust/Makefile" ]; then
  echo "✅ Rust目录替换成功，Makefile存在"
else
  echo "❌ Rust目录替换失败，Makefile不存在"
fi

echo "========================================"
echo "rust 替换完成！"
