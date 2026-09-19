#
# 修改官方openwrt的基础参数，有修改lan的ip地址、定义时区
#!/bin/bash
set -x

cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt
CONFIG_FILE2="package/base-files/files/bin/config_generate"

# -------- 修改基础参数 --------

sed -i 's/{ipaddr:-"192\.168\..*"}/{ipaddr:-"192.168.4.10"}/g' "$CONFIG_FILE2"
sed -i "s/hostname='OpenWrt'/hostname='OfficialWrt'/g" "$CONFIG_FILE2"
sed -i "s/timezone='UTC'/timezone='CST-8'/g" "$CONFIG_FILE2"

if grep -Eq '^[[:space:]]*set system\.@system\[-1\]\.zonename=' "$CONFIG_FILE2"; then
    sed -i \
        "s|^\([[:space:]]*set system\.@system\[-1\]\.zonename=\).*|\1'Asia/Shanghai'|" \
        "$CONFIG_FILE2"
else
    sed -i \
        "/set system\.@system\[-1\]\.timezone='CST-8'/a\\
        set system.@system[-1].zonename='Asia/Shanghai'" \
        "$CONFIG_FILE2"
fi


echo ✅ 基础参数修改完成

# -------- 更改登入界面 --------

cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt/package/base-files/files/etc
cp --backup=numbered banner banner.bak
rm -rf banner
BUILD_DATE=$(date '+%Y-%m-%d %H:%M:%S')
cat <<'EOT' > banner
        Welcome to X86_X64 SoftRouter!
 ----------------------------------------------------- 
  ______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 Version: %D %V,  %C 
 -----------------------------------------------------
 Official OpenWrt Firmware Is Built By YzW
 ...... Building Date: BUILD_DATE ...... 

EOT

sed -i "s|BUILD_DATE|$BUILD_DATE|g" banner
cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt
cp --backup=numbered version version.bak33
#sed -i "1s|-.*|-Firmware Is Built By YzW|g" version #替换-后内容
#sed -i "s|-.*|-BuiltByYZW|g" version #替换-后长度
#sed -i "s|$ |-BuiltByYZW|g" version #原数据后添加，这句实际运行结果查看是什么也没有加
#sed -i "1s|$|+BuiltByYZW|g" version   #第一行原数据尾部后添加 检查错误日志，编译时取-后的字符建了一个1700~加上添加的字符要生成一个ipk文件，这显然不易动这个文件中的内容！
#sed -i "1s|$|  BuiltByYZW|g" version   #第一行原数据空两格添加
#sed -i "2i|*|-FirmwareIsBuiltByYZW|g" version #不动第一行，第二行添加


echo "✅ Custom banner has been set."

