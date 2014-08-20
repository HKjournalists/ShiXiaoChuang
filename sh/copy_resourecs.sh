#!/bin/bash

source info.sh 


echo "修改info.plist的CFBundleDisplayName"
defaults write $app_infoplist_path "CFBundleDisplayName" $DisplayName


echo "display name:"
defaults read $app_infoplist_path "CFBundleDisplayName"

echo $images_path
echo "copy images"
cp -R $images_path $resources

echo "copy icon images"
cp -R $icon_images_path $icon_path




echo "secuss"



