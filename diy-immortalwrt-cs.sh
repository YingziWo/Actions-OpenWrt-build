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
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

set -x 
pwd
ls
# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

#添加项目地址
sed -i 's/cpuusage\.cpuusage/cpuusage.cpuusage,/g' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
sed -i -f ../diy/immortalwrt_10_system.sed feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

#修改镜像源
sed -i 's#mirror.iscas.ac.cn/kernel.org#mirrors.edge.kernel.org/pub#' scripts/download.pl

#修改默认设置
cp -f ../diy/default-settings package/emortal/default-settings/files/99-default-settings

