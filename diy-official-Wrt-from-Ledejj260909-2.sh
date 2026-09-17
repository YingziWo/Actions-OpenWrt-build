#
# 修改官方openwrt的基础参数，有修改lan的ip地址、定义时区
#!/bin/bash
set -e


CONFIG_FILE2=packagebase-filesfilesbinconfig_generate

# -------- 修改基础参数 --------

sed -i 's/{ipaddr:-"192\.168\..*"}/{ipaddr:-"192.168.4.10"}/g' "$CONFIG_FILE"
sed -i "s/hostname='OpenWrt'/hostname='OfficialWrt'/g" "$CONFIG_FILE"
sed -i "s/timezone='UTC'/timezone='CST-8'/g" "$CONFIG_FILE"

if grep -Eq '^[[:space:]]*set system\.@system\[-1\]\.zonename=' "$CONFIG_FILE"; then
    sed -i \
        "s|^\([[:space:]]*set system\.@system\[-1\]\.zonename=\).*|\1'Asia/Shanghai'|" \
        "$CONFIG_FILE"
else
    sed -i \
        "/set system\.@system\[-1\]\.timezone='CST-8'/a\\
        set system.@system[-1].zonename='Asia/Shanghai'" \
        "$CONFIG_FILE"
fi


echo ✅ 基础参数修改完成
