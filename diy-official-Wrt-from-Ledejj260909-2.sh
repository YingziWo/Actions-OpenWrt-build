#
# 修改官方openwrt的基础参数，有修改lan的ip地址、定义时区
#!/bin/bash
set -e


CONFIG_FILE2=packagebase-filesfilesbinconfig_generate

# -------- 修改基础参数 --------

sed -i 's192.168.1.1192.168.50.1g' $CONFIG_FILE2
sed -i shostname='OpenWrt'hostname='OfficialWrt'g $CONFIG_FILE2
sed -i stimezone='UTC'timezone='CST-8'g $CONFIG_FILE2

if grep -Eq '^[[space]]set system.@system[-1].zonename=' $CONFIG_FILE2; then
    sed -i 
        s^([[space]]set system.@system[-1].zonename=).1'AsiaShanghai' 
        $CONFIG_FILE2
else
    sed -i 
        set system.@system[-1].timezone='CST-8'a
        set system.@system[-1].zonename='AsiaShanghai' 
        $CONFIG_FILE2
fi

if [ -f $LUCIMK ]; then
    sed -i 'sluci-theme-bootstrapluci-theme-argong' $LUCIMK
fi

echo ✅ 基础参数修改完成
