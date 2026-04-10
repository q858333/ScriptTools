# ScriptTools

## 1.iOS打包脚本
涉及命令：
xcodebuild clean ，
xcodebuild archive ，
xcodebuild -exportArchive ，

1、如果提示permission denied: ./package.sh ， 则先附加权限，命令如下：chmod 777 package.sh
2、请根据自己项目的情况选择使用 workspace 还是 project 形式，目前默认为 workspace 形式

## 2.Flutter打包iOS脚本
运行脚本./build_ios_ipa.sh, 输入1打adhoc包,2打商店包
