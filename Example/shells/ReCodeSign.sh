#!/bin/sh

#  ReCodeSign.sh
#  WQBasicModules
#
#  Created by iMacHuaSheng on 2021/3/10.
#  Copyright © 2021 CocoaPods. All rights reserved.
#工程文件所在的目录
TEMP_PATH="${SRCROOT}/Temp"
#资源文件夹，我们提前在工程目录下新建一个App文件夹用来放ipa包
ASEETS_PATH="${SRCROOT}/App"
#目标ipa包路径
TARGET_IPA_PATH="${ASEETS_PATH}/*.ipa"
#清空Temp文件夹
rm -rf "${SRCROOT}/Temp"
mkdir -p "${SRCROOT}/Temp"


#-----------------------
#1.解压到IPA到Temp下
unzip -oqq "$TARGET_IPA_PATH" -d "$TEMP_PATH"
#拿到解压的临时App的路径
TEMP_APP_PATH=$(set -- "TEMP_PATH/PlayLoad"*.app;echo "$1")

#-----------------------
#2.将解压出来的.app拷贝进入工程下
# BUILT_PRODUCTS_DIR 工程生成App包的路径
# TARGET_NAME target名称
TARGET_APP_PATH="$BUILT_PRODUCTS_DIR/$TARGET_NAME.app"
echo "app路径:$TARGET_APP_PATH"

rm -rf "$TARGET_APP_PATH"
mkdir -p "$TARGET_APP_PATH"
cp -rf "$TEMP_APP_PATH/" "$TARGET_APP_PATH"

#-----------------------
#3.删除extension 和 watchApp 个人证书无法签名Extension
rm -rf "$TARGET_APP_PATH/PlugIns"
rm -rf "$TARGET_APP_PATH/Watch"

#-----------------------
#4.更新info.plist CFBundleIdentifier
# 设置 "Set : KEY Value" "目标文件路径"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $PRODUCT_BUNDLE_IDENTIFIER" "$TARGET_APP_PATH/Info.plist"

#-----------------------
#5.给MchO文件执行权限
# 拿到MachO文件的路径
APP_BINARY=`plutil -convert xml1 -o -$TARGET_APP_PATH/Info.plist|grep -A1 Exec|tail -n1|cut -f2 -d\>|cut -f1 -d\<`
#上可执行权限
chmod +x "$TARGET_APP_PATH/$APP_BINARY"

#-----------------------
#6.重签名第三方 Frameworks
TARGET_APP_FRAMEWORKS_PATH="$TARGET_APP_PATH/Frameworks"
if [ -d "$TARGET_APP_FRAMEWORKS_PATH" ];
then
for FRAMEWORK in "$TARGET_APP_FRAMEWORKS_PATH/"*
do
#签名
/usr/bin/cpdesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" "$FRAMEWORK"
done
fi
