**English** 

# Actions-OpenWrt

[![immortalwrt_x86_64](https://github.com/YingziWo/Actions-OpenWrt-build/actions/workflows/immortalwrt-builder.yml/badge.svg)](https://github.com/YingziWo/Actions-OpenWrt-build/actions/workflows/immortalwrt-builder.yml)
[![Lede_x86_64](https://github.com/YingziWo/Actions-OpenWrt-build/actions/workflows/openwrt-builder.yml/badge.svg)](https://github.com/YingziWo/Actions-OpenWrt-build/actions/workflows/openwrt-builder.yml)


Cloud Building OpenWrt with the GitHub Actions

## Usage

- Click the [ Template ](https://github.com/YingziWo/Actions-OpenWrt-build) button ，fork to create a new repository.
- Generate `.config` files using [Lean's OpenWrt](https://github.com/coolsnowwolf/lede) source code. ( You can change it through environment variables in the workflow file. )
- Push `.config` file to the GitHub repository.
- Select `openwrt-builder` on the Actions page.
- Click the `Run workflow` button.
- When the build is complete, click the your self [Artifacts](https://github.com/YingziWo/Actions-OpenWrt-build/actions/runs/10750393701) button in the upper right corner of the Actions page to download the binaries.
- When you need to upload the release area, you need to set your GitHub_Token for this repository.

## Tips

- It may take a long time to create a `.config` file and build the OpenWrt firmware. Thus, before create repository to build your own firmware, you may check out if others have already built it which meet your needs by simply [search `Actions-Openwrt-build` in GitHub](https://github.com/search?q=Actions-openwrt).
- Add some meta info of your built firmware (such as firmware architecture and installed packages) to your repository introduction, this will save others' time.

## Credits

- [Microsoft Azure](https://azure.microsoft.com)
- [GitHub Actions](https://github.com/features/actions)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)
- [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)



