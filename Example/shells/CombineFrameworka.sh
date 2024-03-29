#!/bin/sh

#  CombineFrameworka.sh
#  WQBasicModules
#
#  Created by iMacHuaSheng on 2021/4/23.
#  Copyright © 2021 CocoaPods. All rights reserved.
# Type a script or drag a script file from your workspace to insert its path.


if [ "${ACTION}" = "build" ]
then
INSTALL_DIR=${SRCROOT}/Products/${PROJECT_NAME}.framework

DEVICE_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework

SIMULATOR_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework

# 如果真机包或模拟包不存在，则退出合并
if [ ! -d "${DEVICE_DIR}" ] || [ ! -d "${SIMULATOR_DIR}" ]
then
exit 0
fi

# 如果合并包已经存在，则替换
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

# 使用lipo命令将其合并成一个通用framework
# 最后将生成的通用framework放置在工程根目录下新建的Products目录下
lipo -create "${DEVICE_DIR}/${PROJECT_NAME}" "${SIMULATOR_DIR}/${PROJECT_NAME}" -output "${INSTALL_DIR}/${PROJECT_NAME}"

#合并完成后打开目录
open "${SRCROOT}/Products"

fi
