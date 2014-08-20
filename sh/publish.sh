#!/bin/bash

source info.sh 



echo "创建production目录"

rm -rf "$production/$name$bundleShortVersion.ipa"
mkdir $production

echo "生成ipa包"

xcrun -sdk iphoneos packageapplication -v "$build/$name.app" -o "$production/$name$bundleShortVersion.ipa"




echo "生成ipa成功"


