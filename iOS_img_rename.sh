#!/bin/zsh
#iOS图片文件重命名
#$1 原字符串 $2 目标字符串 $3 2x,3x
 ~/myshells/rename.sh $3 ""
 ~/myshells/rename.sh $1 $2
 ~/myshells/rename.sh "_0" "_"
 ~/myshells/rename.sh ".png" $3".png"

