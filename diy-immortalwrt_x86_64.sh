#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-immortalwrt_x86_64.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
# 2024年10月3日 作者kiddin9不知道什么原因，突然删除了自己的openwrt-packages的仓库，以下涉及他的仓库openwrt-packages的引用都必须更改。
# On October 3, 2024, the author kiddin9 suddenly deleted his openwrt-packages repository for unknown reasons. The following references to his repository openwrt-packages must be changed.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

set -x 
pwd
ls
# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
##########################################添加额外包##########################################

# Git稀疏克隆，只克隆指定目录到本地
mkdir -p package/yingziwo

function git_sparse_clone() {
 branch="$1" repourl="$2" && shift 2
 git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
 repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
 cd $repodir && git sparse-checkout set $@
 mv -f $@ ../package/yingziwo
 cd .. && rm -rf $repodir
}


# 移除冲突包
# rm -rf feeds/packages/net/mosdns
#rm -rf feeds/packages/net/msd_lite
#rm -rf feeds/packages/net/smartdns
#rm -rf feeds/luci/themes/luci-theme-argon
#rm -rf feeds/small8/shadowsocks-rust

#lucky
# git clone  https://github.com/gdy666/luci-app-lucky.git package/lucky

#luci-theme-argone
#git_sparse_clone main https://github.com/kenzok8/small-package luci-theme-argone       # argone for 18.06 , argon for 23.x
#git_sparse_clone main https://github.com/kenzok8/small-package luci-app-argone-config
##git_sparse_clone master https://github.com/jerrykuku/luci-theme-argon luci-theme-argon                 #适应于23.05，这是原作者的链接
##git_sparse_clone master https://github.com/jerrykuku/luci-app-argon-config luci-app-argon-con


#luci-app-store
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-store      # kiddin9已经在2024.10.3 删库，不能使用！
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-lib-taskd
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-lib-xterm
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages taskd
git_sparse_clone main https://github.com/linkease/istore luci/luci-app-store
git_sparse_clone main https://github.com/linkease/istore luci/luci-lib-taskd
git_sparse_clone main https://github.com/linkease/istore luci/luci-lib-xterm
git_sparse_clone main https://github.com/linkease/istore luci/taskd
#更换插件名称
sed -i 's/("iStore"),/("软件仓库"),/g' package/yingziwo/luci-app-store/luasrc/controller/store.lua

#adguardhome
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-adguardhome
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages adguardhome
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-adguardhome

#科学上网
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-openclash
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-passwall
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ssr-plus
##git_sparse_clone main https://github.com/kenzok8/small-package luci-app-openclash
#git_sparse_clone main https://github.com/kenzok8/small luci-app-passwall    #启用原passwall作者的仓库，以便跟上更新，这个第三方的注释掉
git_sparse_clone 4.78-2 https://github.com/xiaorouji/openwrt-passwall luci-app-passwall     #原始作者仓库源 4.78-2是稳定版，在lede20230609版上运行正常，2024.10.05作者推出4.78-3版本
#git_sparse_clone master https://github.com/kenzok8/small luci-app-ssr-plus    #与第20句内容的功能一样，这里注释
#更换插件名称
#sed -i 's/ShadowSocksR Plus+/软件插件/g' feeds/small8/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

#ddns-go
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages ddns-go
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ddns-go
# rm -rf feeds/small8/ddns-go feeds/small8/luci-app-ddns-go
# git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo

#Netdata
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages netdata
#git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/yingziwo/luci-app-netdata
# 调整 netdata 到 服务 菜单
#sed -i 's/"system"/"services"/g' feeds/luci/applications/luci-app-netdata/luasrc/controller/*.lua
#sed -i 's/"system"/"services"/g' feeds/luci/applications/luci-app-netdata/luasrc/model/cgi/*.lua
#sed -i 's/admin\/system/admin\/services/g' feeds/luci/applications/luci-app-netdata/luasrc/view/netdata/*.htm

#mosdns
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages mosdns
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-mosdns
# 修复插件冲突
#rm -rf feeds/small8/luci-app-mosdns/root/etc/init.d

#zerotier
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-zerotier
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages zerotier

#luci-app-autotimeset
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-autotimeset
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-autotimeset

########依赖包########
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages brook
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages chinadns-ng
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages dns2socks
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages dns2tcp
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages gn
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages hysteria
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages ipt2socks
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages microsocks
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages naiveproxy
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages pdnsd-alt
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocksr-libev
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocks-rust
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages simple-obfs
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages sing-box
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages ssocks
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages ssocks
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages tcping
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan-go
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan-plus
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages tuic-client
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages v2ray-core
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages v2ray-geodata
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages v2ray-plugin
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages xray-core
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages xray-plugin
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages lua-neturl
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages mosdns
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages redsocks2
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadow-tls
git_sparse_clone master https://github.com/kenzok8/small shadow-tls         
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages lua-maxminddb
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages v2dat
git_sparse_clone v5 https://github.com/sbwml/luci-app-mosdns v2dat

##########################################其他设置##########################################

# 修改默认登录地址
sed -i 's/192.168.1.1/192.168.4.198/g' ./package/base-files/files/bin/config_generate

# 修改默认登录密码
#sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' ./package/base-files/files/etc/shadow



# 修改内核版本
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=5.15/g' ./target/linux/x86/Makefile
#sed -i 's/KERNEL_TESTING_PATCHVER:=5.15/KERNEL_TESTING_PATCHVER:=5.10/g' ./target/linux/x86/Makefile

# TTYD 免登录
#sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config


#添加项目地址
#sed -i 's/cpuusage\.cpuusage/cpuusage.cpuusage,/g' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#sed -i -f ../diy/immortalwrt_10_system.sed feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

#修改镜像源
#sed -i 's#mirror.iscas.ac.cn/kernel.org#mirrors.edge.kernel.org/pub#' scripts/download.pl

#修改默认设置
#cp -f ../diy/default-settings package/emortal/default-settings/files/99-default-settings

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}
