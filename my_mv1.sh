#!/bin/sh
#查找当前文件夹下的一般文件，移动到指定目录。
find . -type f | xargs -I {} mv {} $1
