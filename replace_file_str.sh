#!/bin/sh
# 替换当前目录下文件中特定的字符串
# 针对Mac平台，在sed -i 后面添加 ''

sed -i '' "s/$1/$2/g" `grep $1 -rl .`
