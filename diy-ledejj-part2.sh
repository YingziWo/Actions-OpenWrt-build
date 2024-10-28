#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

set -x 
pwd
ls

# Modify default IP   #新版lede master原码仅这条是更改不了缺省ip地址，需要更改缺省的flash.js共同作用来实现
sed -i 's/192.168.1.1/192.168.4.100/g' package/base-files/files/bin/config_generate

#修改openwrt.lan关联IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192.168.4.10/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")

#添加项目地址
#sed -i '/<tr><td width="33%"><%:CPU usage (%)%><\/td><td id="cpuusage">-<\/td><\/tr>/a <tr><td width="33%"><%:Github项目%><\/td><td><a href="https:\/\/github.com\/lmxslpc\/OpenWrt-Build-System" target="_blank">云编译系统<\/a><\/td><\/tr>' ./package/lean/autocore/files/x86/index.htm
# sed -i '/<tr><td width="33%"><%:CPU usage (%)%><\/td><td id="cpuusage">-<\/td><\/tr>/a <tr><td width="33%"><%:Github项目%><\/td><td><a href="https:\/\/github.com\/YingziWo\/OpenWrt-Build-System" target="_blank">云编译系统<\/a><\/td><\/tr>' ./package/lean/autocore/files/x86/index.htm
#sed -i '/<tr><td width="33%"><%:CPU usage (%)%><\/td><td id="cpuusage">-<\/td><\/tr>/a <tr><td width="33%"><%:Github项目%><\/td><td><a href="https:\/\/github.com\/YingziWo\/Actions-OpenWrt-build" target="_blank">云编译系统<\/a><\/td><\/tr>' ./package/lean/autocore/files/x86/index.htm
sed -i '/<tr><td width="33%"><%:CPU usage (%)%><\/td><td id="cpuusage">-<\/td><\/tr>/a <tr><td width="33%"><%:Github Project%><\/td><td><a href="https:\/\/github.com\/YingziWo\/Actions-OpenWrt-build" target="_blank">Actions-Build-System<\/a><\/td><\/tr>' ./package/lean/autocore/files/x86/index.htm

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
