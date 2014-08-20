#!/bin/bash

source info.sh 


#-1.替换文件------------------------------------------------------------------------------------------------------------------------------

echo "修改info.plist的CFBundleDisplayName"
defaults write $app_infoplist_path "CFBundleDisplayName" $DisplayName


echo "display name:"
defaults read $app_infoplist_path "CFBundleDisplayName"


echo "copy images"
cp -R $images_path $resources

echo "copy icon images"
cp -R $icon_images_path $icon_path

#-2.编译生成app------------------------------------------------------------------------------------------------------------------------------


echo "编译项目到build目录"
echo "开始编译"


xcodebuild -configuration Release -workspace "$SRCROOT/$appname.xcworkspace"  -scheme "$appname" CONFIGURATION_BUILD_DIR="$build"


echo "生成成功"




#-3.生成ipa------------------------------------------------------------------------------------------------------------------------------
echo "创建production目录"
mkdir $production

echo "生成ipa包"
xcrun -sdk iphoneos packageapplication -v "$build/$appname.app" -o "$production/$appname$bundleShortVersion.ipa"
echo "生成ipa成功"




#-4.上传服务器------------------------------------------------------------------------------------------------------------------------------
# 请提前copy sshid 到服务器 （ssh-copy-id）
# scp -P 899 $local_ipa_path $server_path
echo "开始cp到服务器"

echo "正在上传到服务器"
echo "请稍等。。。"

scp $local_ipa_path $server_path


echo "cp到服务器成功"













