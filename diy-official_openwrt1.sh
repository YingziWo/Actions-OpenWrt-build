#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
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
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default                      #仅支持openwrt21.02版本或以下
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

#=================================================
# 自定义
#=================================================
##########################################添加额外包##########################################

# Git稀疏克隆，只克隆指定目录到本地
pwd
ls -la
mkdir -p package/yingziwo
pwd

function git_sparse_clone() {
 branch="$1" repourl="$2" && shift 2
 git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
 repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
 cd $repodir && git sparse-checkout set $@
 mv -f $@ ../package/yingziwo
 cd .. && rm -rf $repodir
}
pwd

#lucky
#git clone  https://github.com/gdy666/luci-app-lucky.git package/lucky

# 移除冲突包
rm -rf feeds/packages/net/mosdns
#rm -rf feeds/packages/net/msd_lite
#rm -rf feeds/packages/net/smartdns
#rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
#rm -rf feeds/small8/shadowsocks-rust

#luci-theme-argone
#git_sparse_clone main https://github.com/kenzok8/small-package luci-theme-argone                      #official-openwrt23.05不支持这个主题界面 argone for 18.06
#git_sparse_clone main https://github.com/kenzok8/small-package luci-app-argone-config
#git_sparse_clone master https://github.com/jerrykuku/luci-theme-argon luci-theme-argon                 # argon适应于23.05，这是原作者的链接。同时支持改master --》 18.06版本 
#git_sparse_clone master https://github.com/jerrykuku/luci-app-argon-config luci-app-argon-config
git_sparse_clone main https://github.com/kenzok8/small-package luci-theme-argon
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-argon-config

#luci-app-store
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-store
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-lib-taskd   #更新不及时，版本在最新的openwrt版本和最新的内核下编译报错版本太低要升级。因此改用iStore的源头linkease下
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-lib-xterm
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages taskd
git_sparse_clone main https://github.com/linkease/istore luci/luci-app-store
git_sparse_clone main https://github.com/linkease/istore luci/luci-lib-taskd
git_sparse_clone main https://github.com/linkease/istore luci/luci-lib-xterm
git_sparse_clone main https://github.com/linkease/istore luci/taskd
ls -al package/yingziwo
#更换插件名称
sed -i 's/("iStore"),/("软件仓库"),/g' package/yingziwo/luci-app-store/luasrc/controller/store.lua

#adguardhome
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-adguardhome
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-adguardhome
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages adguardhome

#科学上网
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-openclash
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-openclash
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-passwall
git_sparse_clone 4.78-2 https://github.com/xiaorouji/openwrt-passwall luci-app-passwall       #换源头到xiaorouji上，降低内核版本换回原来的源，4.78-2无bug ，4.78-3和main都有bug
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ssr-plus
##git_sparse_clone master https://github.com/fw876/helloworld luci-app-ssr-plus               #换源头到fw876上 ，哈，源头的只支持For OpenWrt 21.02 or lower version 和 You have to manually upgrade Golang toolchain to 1.21 or higher to compile Xray-core. 这是要在openwrt23.05版本上，不能用

#更换插件名称
#sed -i 's/ShadowSocksR Plus+/软件插件/g' feeds/small8/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

#ddns-go
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages ddns-go
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ddns-go
git_sparse_clone main https://github.com/kenzok8/small-package ddns-go
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-ddns-go
# rm -rf feeds/small8/ddns-go feeds/small8/luci-app-ddns-go
# git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo

#Netdata
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages netdata
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/yingziwo/luci-app-netdata
sed -i 's/"status"/"system"/g' package/yingziwo/luci-app-netdata/luasrc/controller/*.lua
sed -i 's/"status"/"system"/g' package/yingziwo/luci-app-netdata/luasrc/model/cgi/*.lua
sed -i 's/admin\/status/admin\/system/g' package/yingziwo/luci-app-netdata/luasrc/view/netdata/*.htm

#mosdns
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages mosdns
#git_sparse_clone v5 https://github.com/sbwml/luci-app-mosdns luci-app-mosdns #编译中报错，去除于24.09.13
#git_sparse_clone v5 https://github.com/sbwml/luci-app-mosdns mosdns          #编译中报错，去除于24.09.13
##rm -rf feeds/packages/utils/v2dat
##rm -rf package/feeds/packages/v2dat
# git_sparse_clone v5 https://github.com/sbwml/luci-app-mosdns v2dat          #编译中报错，去除于24.09.13


#zerotier
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-zerotier
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages zerotier

#luci-app-autotimeset
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-autotimeset
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-autotimeset  

########依赖包########
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages brook
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages chinadns-ng
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages dns2socks
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages dns2tcp
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages gn
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages hysteria                        #编译报警级别的提示后增加，其他是编译报错级别的增加
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages ipt2socks
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages microsocks
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages naiveproxy                      #编译报警级别的提示后增加，其他是编译报错级别的增加
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages pdnsd-alt
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocksr-libev     
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocks-rust        
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages simple-obfs
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages sing-box                        
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages ssocks
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages tcping
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan-go
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan-plus
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages tuic-client                      #编译报警级别的提示后增加，其他是编译报错级别的增加
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages v2ray-core
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages v2ray-geodata
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages v2ray-plugin
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages xray-core
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages xray-plugin                      #编译报警级别的提示后增加，其他是编译报错级别的增加
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages lua-neturl
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages redsocks2
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadow-tls
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages lua-maxminddb

##########################################其他设置##########################################
########依赖包######## from diy-immortalwrt_x86_64.sh 的配置
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
 ###git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocksr-libev             #official-openwrt-main版本的依赖，23.05不需要
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocks-rust              
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages simple-obfs
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages sing-box
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages ssocks
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages tcping
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan
 #git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan-go       #下面这句是编译中报passwall缺少该依赖 240920
##git_sparse_clone master https://github.com/kiddin9/openwrt-packages trojan-plus       
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
####################### 改用xiaorouji源头的依赖代码########################################
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages brook
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages chinadns-ng
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages dns2socks
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages dns2tcp
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages gn
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages hysteria
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages ipt2socks
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages microsocks
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages naiveproxy
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages pdnsd-alt
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages shadowsocks-rust
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages shadowsocksr-libev
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages simple-obfs
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages sing-box
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages ssocks
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages tcping
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages trojan-go
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages trojan-plus
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages trojan
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages tuic-client
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages v2ray-core
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages v2ray-geodata
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages v2ray-plugin
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages xray-core
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall-packages xray-plugin

#############################################################################################

############改用fw876的ssr-plus源头自己的依赖，若与上面的passwall依赖重复，是否要注释掉，注意编译信息 oepwnwrt23.05下版本太高不支持##########
#git_sparse_clone master https://github.com/fw876/helloworld chinadns-ng
#git_sparse_clone master https://github.com/fw876/helloworld dns2socks
#git_sparse_clone master https://github.com/fw876/helloworld dns2tcp
#git_sparse_clone master https://github.com/fw876/helloworld gn
#git_sparse_clone master https://github.com/fw876/helloworld hysteria
#git_sparse_clone master https://github.com/fw876/helloworld pt2socks
#git_sparse_clone master https://github.com/fw876/helloworld lua-neturl
#git_sparse_clone master https://github.com/fw876/helloworld microsocks
#git_sparse_clone master https://github.com/fw876/helloworld mosdns
#git_sparse_clone master https://github.com/fw876/helloworld naiveproxy
#git_sparse_clone master https://github.com/fw876/helloworld redsocks2
#git_sparse_clone master https://github.com/fw876/helloworld shadow-tls
#git_sparse_clone master https://github.com/fw876/helloworld shadowsocks-rust
#git_sparse_clone master https://github.com/fw876/helloworld shadowsocksr-libev
#git_sparse_clone master https://github.com/fw876/helloworld simple-obfs
#git_sparse_clone master https://github.com/fw876/helloworld tcping
#git_sparse_clone master https://github.com/fw876/helloworld trojan
#git_sparse_clone master https://github.com/fw876/helloworld tuic-client
#git_sparse_clone master https://github.com/fw876/helloworld v2ray-core
#git_sparse_clone master https://github.com/fw876/helloworld v2ray-plugin
#git_sparse_clone master https://github.com/fw876/helloworld v2raya
#git_sparse_clone master https://github.com/fw876/helloworld xray-core
#git_sparse_clone master https://github.com/fw876/helloworld xray-plugin
##############################################################################################


# 更改 Argon 主题背景
#cp -f $GITHUB_WORKSPACE/images/bg.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg.jpg


# 修改默认登录地址
##sed -i 's/192.168.1.1/10.1.1.254/g' ./package/base-files/files/bin/config_generate

#2. 修改默认登录密码
##sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' ./package/lean/default-settings/files/zzz-default-settings

# 修改内核版本
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=5.15/g' ./target/linux/x86/Makefile
#sed -i 's/KERNEL_TESTING_PATCHVER:=5.15/KERNEL_TESTING_PATCHVER:=5.10/g' ./target/linux/x86/Makefile

# TTYD 免登录
#sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

#添加项目地址
#sed -i '/<tr><td width="33%"><%:CPU usage (%)%><\/td><td id="cpuusage">-<\/td><\/tr>/a <tr><td width="33%"><%:Github项目%><\/td><td><a href="https:\/\/github.com\/lmxslpc\/OpenWrt-Build-System" target="_blank">云编译系统<\/a><\/td><\/tr>' ./package/lean/autocore/files/x86/index.htm
# sed -i '/<tr><td width="33%"><%:CPU usage (%)%><\/td><td id="cpuusage">-<\/td><\/tr>/a <tr><td width="33%"><%:Github项目%><\/td><td><a href="https:\/\/github.com\/YingziWo\/OpenWrt-Build-System" target="_blank">云编译系统<\/a><\/td><\/tr>' ./package/lean/autocore/files/x86/index.htm
##sed -i '/<tr><td width="33%"><%:CPU usage (%)%><\/td><td id="cpuusage">-<\/td><\/tr>/a <tr><td width="33%"><%:Github项目%><\/td><td><a href="https:\/\/github.com\/YingziWo\/Actions-OpenWrt-build" target="_blank">云编译固件项目<\/a><\/td><\/tr>' ./package/lean/autocore/files/x86/index.htm

# 修改本地时间格式
##sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

#修改镜像源
##sed -i 's#mirror.iscas.ac.cn/kernel.org#mirrors.edge.kernel.org/pub#' scripts/download.pl

# 修改版本为编译日期
##date_version=$(date +"%y.%m.%d")
##orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
#sed -i "s/${orig_version}/R${date_version} by Yingziwo/g" package/lean/default-settings/files/zzz-default-settings
##sed -i "s/${orig_version}/R${date_version} by Yingziwo/g" package/lean/default-settings/files/zzz-default-settings

#删除无效opkg源
##sed -i '/exit 0/i sed -i "/kenzok8/d" /etc/opkg/distfeeds.conf' ./package/lean/default-settings/files/zzz-default-settings
##sed -i '/exit 0/i sed -i "/kenzo/d" /etc/opkg/distfeeds.conf' ./package/lean/default-settings/files/zzz-default-settings
##sed -i '/exit 0/i sed -i "/small/d" /etc/opkg/distfeeds.conf' ./package/lean/default-settings/files/zzz-default-settings

#删除多余文件
##sed -i '/exit 0/i\rm -f /etc/config/adguardhome\nrm -f /etc/init.d/adguardhome' ./package/lean/default-settings/files/zzz-default-settings



# 修改 Makefile
##find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
##find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
##find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
##find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 替换go版本到1.22.x  -- > default
rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
ls -al package/yingziwo

