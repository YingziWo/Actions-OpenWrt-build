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

# 以下是固件显示面板中增加版本编译地址url, 这段代码要小心调整，不知到用途勿随意调整，易造成编译失败
cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt/package/feeds/luci/luci-theme-bootstrap/ucode/template/themes/bootstrap
#sed -i 's|{"{{ entityencode(version.disturl ?? ''#'', true) }}"}/{"https://github.com/YingziWo/Actions-OpenWrt-build/releases"}/g' footer.ut
#sed -i 's|{"{{ version.distname }} {{ version.distversion }} ({{ version.distrevision }})"}/{"{{ version.distname }} {{ version.distversion }} ({{ version.distrevision }}) Firmware Is Built By YzW"}/g' footer.ut
rm -rf footer.ut
cat <<'EOT' > footer.ut
		{% if (!blank_page): %}
		</div>
		<footer>
			<span>
				Powered by
				<a href="https://github.com/openwrt/luci" target="_blank" rel="noreferrer">
					{{ version.luciname }} ({{ version.luciversion }})</a>
				/
				<a href="https://github.com/YingziWo/Actions-OpenWrt-build/releases" target="_blank" rel="noreferrer">
					{{ version.distname }} {{ version.distversion }} ({{ version.distrevision }}) Firmware Is Built By YzW</a>
				{% if (lua_active): %}
					/ {{ _('Lua compatibility mode active') }}
				{% endif %}
			</span>
			<ul class="breadcrumb pull-right" id="modemenu" style="display:none"></ul>
		</footer>
		<script>L.require('menu-bootstrap')</script>
		{% endif %}
	</body>
</html>

EOT

cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt/package/feeds/luci/luci-theme-footstrap/ucode/template/themes/footstrap/partials
rm -rf footer.ut
cat <<'EOT' > footer.ut
{#
 Footer body. ONE layout template and ONE client menu renderer — sidebar and top bar are
 the same markup, morphed by :root[data-layout] — so the old `menu_module` parameter that
 picked between two renderers is gone with the second one.
 Licensed to the public under the Apache License 2.0.
-#}
		{% if (!blank_page): %}
				</div>{# /.fs-content #}

				{#
					role="contentinfo" is explicit because a <footer> only gets it IMPLICITLY
					when its nearest ancestor is <body>, and this one lives inside <main> —
					where it must stay: both layouts lay .fs-main out as a flex column and order
					the footer within it. The explicit role escapes that scoping rule.
					The version strings are entityencode()d: /etc/openwrt_release is root-owned,
					but an unescaped `&` in a distname would still break the markup.
				#}
				<footer class="fs-footer" role="contentinfo">
					<span>
						Powered by
						<a href="https://github.com/openwrt/luci" target="_blank" rel="noreferrer">
							{{ entityencode(version.luciname, true) }} ({{ entityencode(version.luciversion, true) }})</a>
						/
						<a href="https://github.com/YingziWo/Actions-OpenWrt-build/releases" target="_blank" rel="noreferrer">
							{{ entityencode(version.distname, true) }} {{ entityencode(version.distversion, true) }} ({{ entityencode(version.distrevision, true) }}) Frimware Is Built By YzW</a>
						{% if (lua_active): %}
							/ {{ _('Lua compatibility mode active') }}
						{% endif %}
					</span>
				</footer>
			</main>{# /.fs-main #}
		</div>{# /.fs-shell #}
		<script>L.require('menu-footstrap')</script>
		<script>L.require('fs-select')</script>
		{% endif %}
	</body>
</html>

EOT

cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt/feeds/luci/themes/luci-theme-openwrt/ucode/template/themes/openwrt.org
rm -rf footer.ut
cat <<'EOT' > footer.ut
{#
 Copyright 2008 Steven Barth <steven@midlink.org>
 Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
 Licensed to the public under the Apache License 2.0.
-#}

<div class="clear"></div>
</div>
</div>

<p class="luci">
	Powered by {{ version.luciname }} ({{ version.luciversion }})  Frimware Is Built By YzW
</p>

<script>L.require('menu-openwrt')</script>

</body>
</html>

EOT


cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt/feeds/luci/themes/luci-theme-openwrt-2020/ucode/template/themes/openwrt2020
rm -rf footer.ut
cat <<'EOT' > footer.ut
{#
 Copyright 2020 Jo-Philipp Wich <jo@mein.io>
 Licensed to the public under the Apache License 2.0.
-#}

</div>
</div>

<p class="luci">
	Powered by {{ version.luciname }} ({{ version.luciversion }})  Frimware Is Built By YzW
</p>

<script>L.require('menu-openwrt2020')</script>

</body>
</html>


EOT

cd /home/runner/work/Actions-OpenWrt-build/Actions-OpenWrt-build/openwrt/package/yingziwo/luci-theme-argon/ucode/template/themes/argon
#sed -i 's|{"{{ version.distname }} {{ version.distversion }}-{{ version.distrevision }}"}/{"Version {{ version.distname }} {{ version.distversion }}-{{ version.distrevision }} Frimware Is Built By YzW"}/g' footer_login.ut
#sed -i 's|{"{{ version.disturl }}"}/{"https://github.com/YingziWo/Actions-OpenWrt-build/releases"}/g'  footer_login.ut
rm -rf footer_login.ut
cat <<'EOT' > footer_login.ut
{#
	Argon is a clean HTML5 theme for LuCI. It is based on luci-theme-material Argon Template

	luci-theme-argon
	Copyright 2020 Jerrykuku <jerrykuku@qq.com>

	Have a bug? Please create an issue here on GitHub!
	https://github.com/jerrykuku/luci-theme-argon/issues

	luci-theme-material:
	Copyright 2015 Lutty Yang <lutty@wcan.in>

	Agron Theme
	https://demos.creative-tim.com/argon-dashboard/index.html

	Licensed to the public under the Apache License 2.0
-#}

</div>
<!-- added style="text-wrap: auto" but on this page it is still not the best solution. I will take it to consideration next time :) -->
<footer style="text-wrap: auto">
	<div>
		<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by {{ version.luciname }} ({{ version.luciversion }})</a>
		<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme {# vPKG_VERSION #}</a>
		<a class="luci-link" href="https://github.com/YingziWo/Actions-OpenWrt-build/releases" target="_blank">Version {{ version.distname }} {{ version.distversion }}-{{ version.distrevision }} Frimware Is Built By YzW</a>
	</div>
</footer>
</div>
</div>
<script>
	// thanks for Jo-Philipp Wich <jow@openwrt.org>
	var luciLocation = {{ ctx.path }};
	var winHeight = window.innerHeight;
	window.addEventListener('resize', function () {
		var winWidth = window.innerWidth;
		if(winWidth < 600){
			var newHeight = window.innerHeight;
			var keyboradHeight = newHeight - winHeight;
			var ftcElement = document.querySelector(".ftc");
			if (ftcElement) {
				ftcElement.style.bottom = (keyboradHeight + 30) + "px";
			}
		}
	});
</script>
</body>
</html>
EOT

rm -rf footer.ut
cat <<'EOT' > footer.ut
{#
	Argon is a clean HTML5 theme for LuCI. It is based on luci-theme-material Argon Template

	luci-theme-argon
	Copyright 2020 Jerrykuku <jerrykuku@qq.com>

	Have a bug? Please create an issue here on GitHub!
	https://github.com/jerrykuku/luci-theme-argon/issues

	luci-theme-material:
	Copyright 2015 Lutty Yang <lutty@wcan.in>

	Agron Theme
	https://demos.creative-tim.com/argon-dashboard/index.html

	Licensed to the public under the Apache License 2.0
-#}

		</div>
		<footer class="mobile-hide" style="text-wrap: auto">
			<div class="footer-content" style="display: flex; flex-wrap: wrap; gap: 0.5em; justify-content: end;">

				<a class="luci-link" href="https://github.com/YingziWo/Actions-OpenWrt-build/releases" target="_blank">{{ version.distname }} {{ version.distversion }}-{{ version.distrevision }} Frimware Is Built By YzW</a>

				<ul class="breadcrumb pull-right" id="modemenu" style="display:none"></ul>
			</div>
		</footer>
	</div>
</div>
<script>
	// thanks for Jo-Philipp Wich <jow@openwrt.org>
	var luciLocation = {{ ctx.path }};
	var winHeight = window.innerHeight;
	window.addEventListener('resize', function () {
		var winWidth = window.innerWidth;
		if(winWidth < 600){
			var newHeight = window.innerHeight;
			var keyboradHeight = newHeight - winHeight;
			var ftcElement = document.querySelector(".ftc");
			if (ftcElement) {
				ftcElement.style.bottom = (keyboradHeight + 30) + "px";
			}
		}
	});
</script>
<script type="text/javascript">L.require('menu-argon')</script>
</body>
</html>

EOT

#cp --backup=numbered version version.bak33
#sed -i "1s|-.*|-Firmware Is Built By YzW|g" version #替换-后内容
#sed -i "s|-.*|-BuiltByYZW|g" version #替换-后长度
#sed -i "s|$ |-BuiltByYZW|g" version #原数据后添加，这句实际运行结果查看是什么也没有加
#sed -i "1s|$|+BuiltByYZW|g" version   #第一行原数据尾部后添加 检查错误日志，编译时取-后的字符建了一个1700~加上添加的字符要生成一个ipk文件，这显然不易动这个文件中的内容！ERROR: package/base-files failed to build.
#sed -i "1s|$|  BuiltByYZW|g" version   #第一行原数据空两格添加
#sed -i "2i|*|-FirmwareIsBuiltByYZW|g" version #不动第一行，第二行添加


echo "✅ Custom banner has been set."

