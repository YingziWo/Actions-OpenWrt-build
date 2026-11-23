#!/bin/bash
set -x 
# cd openwrt  #本身就在openwrt下，会报没有该目录或文件的错误，会触发set -e而立刻终止执行下面的步骤
# 注意：bpf-linker的版本号，取自后面步骤中检测到的版本来确定的，其实安装应该放到检测步骤后面进行
pwd
echo "开始替换 feeds中的rust ..."
echo "========================================"

rm -rf ./feeds/packages/lang/rust
#cp -r patches/rust openwrt/feeds/packages/lang/                   #在github环境下，用下面的语句
cp -rf $GITHUB_WORKSPACE/patches/rust ./feeds/packages/lang/rust
#cp -f $GITHUB_WORKSPACE/images/bg.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

echo "===== 查看rust文件是否存在 ====="
ls -lah ./feeds/packages/lang/ | grep rust

# 额外验证Makefile是否存在（核心文件）
if [ -f "./feeds/packages/lang/rust/Makefile" ]; then
  echo "✅ Rust目录替换成功，Makefile存在"
else
  echo "❌ Rust目录替换失败，Makefile不存在"
fi

echo "========================================"
echo "rust 替换完成！"

#echo "开始给宿主机安装bpf-linker中的 ..."
#echo "========================================"
##cargo install bpf-linker --version 0.11.0 --locked
##sudo ln -sf "$HOME/.cargo/bin/bpf-linker" /usr/local/bin/bpf-linker
####gh release download v0.11.0 -R aya-rs/bpf-linker -p "bpf-linker-x86_64-unknown-linux-musl.tar.zst" -D /tmp
####sudo tar --zstd -xf /tmp/bpf-linker-x86_64-unknown-linux-musl.tar.zst -C /usr/local/bin
####rm -f /tmp/bpf-linker-x86_64-unknown-linux-musl.tar.zst
####bpf-linker --version
#FILE="bpf-linker-x86_64-unknown-linux-musl.tar.zst"
#HOST="https://github.com"
#PATH_URL="/aya-rs/bpf-linker/releases/download/v0.11.0/${FILE}"

## 1. 优先尝试 gh 下载；若失败自动切换 curl 兜底（if 条件内的报错不会触发 set -e）
#if ! gh release download v0.11.0 -R aya-rs/bpf-linker -p "$FILE" -D /tmp; then
##if ! gh release download v0.11.0 -R aya-rs/bpf-linker -p "bpf-linker-x86_64-unknown-linux-musl.tar.zst" -D /tmp; then
#    echo "⚠️ gh 下载失败，自动切换为 curl 直链下载..."
#    curl -fsSL "${HOST}${PATH_URL}" -o "/tmp/${FILE}"
#fi

## 2. 解压并清理临时文件（若解压失败，set -e 会在此处直接终止脚本）
#sudo tar --zstd -xf "/tmp/${FILE}" -C /usr/local/bin
#rm -f "/tmp/${FILE}"

## 3. 最终验证版本：成功则继续 Actions，失败则打印提示并 exit 1 终止整个任务
#if bpf-linker --version; then
#    echo "✅ bpf-linker 安装成功，继续执行后续编译步骤..."
#else
#    echo "❌ bpf-linker 安装或验证失败，终止 GitHub Actions！"
#    exit 1
#fi
#echo "========================================"
#echo "bpf-linker 安装完成！"
