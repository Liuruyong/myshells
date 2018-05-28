#!/bin/sh

# 根据输入的参数修改VMWare虚拟机序列号和Mac地址
# 输入参数 “12位序列号,AABBCCDDEEFF” 序列号+Mac地址

if  [ ! -n "$1" ] ; then
	echo "$1 , file not exist!"
else
	echo "$1"
fi


if  [ ! -n "$2" ] ;then
	echo "IS NULL"
else
	OLD_IFS="$IFS" 
	IFS="," 
	arr=($2) 
	IFS="$OLD_IFS"
	SerialNumber=${arr[0]}
	MacAddress=${arr[1]}

	#Mac地址修改
	MacAddress=${MacAddress:0:2}:${MacAddress:2:2}:${MacAddress:4:2}:${MacAddress:6:2}:${MacAddress:8:2}:${MacAddress:10:2}
	sed -E -i "" "s/[0-9a-fA-F:]{17}/$MacAddress/" $1

	#替换序列号
	sed -i "" "/serialNumber/d" $1
	sed -i "" "3i\ 
		serialNumber = $SerialNumber
		" $1

fi
