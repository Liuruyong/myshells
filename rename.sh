#!/bin/sh
#目录下文件重命名 把文件名中的特定字符串替换掉.
#$2 原来的串
#$3 要替换成的串
targetStr=$2
newTargetStr=$3

for filePath in $1/*; do
	file_name=`basename $filePath`
	# 判断文件名中是否包含某个字符串
	if [[ "$file_name" == *"$targetStr"* ]]; then
		newStr=${file_name/$targetStr/$newTargetStr}
		mv $file_name $newStr	
	fi
done
