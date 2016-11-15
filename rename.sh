#!/bin/sh
#当前目录下文件重命名 把文件名中的特定字符串替换掉.
#$1 原来的串
#$2 要替换成的串
targetStr=$1
newTargetStr=$2

for filePath in ./*; do
	file_name=`basename $filePath`
	# 判断文件名中是否包含某个字符串
	if [[ "$file_name" == *"$targetStr"* ]]; then
		newStr=${file_name/$targetStr/$newTargetStr}
		mv $file_name $newStr	
	fi
done
