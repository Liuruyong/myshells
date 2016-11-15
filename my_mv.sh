#!/bin/sh
# 查找当前目录下的文件，移动到指定目录

ls -l |grep '^-'|awk {'print $9'} |xargs -I {} mv {} $1
