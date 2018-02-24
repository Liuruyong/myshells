#!/bin/sh
file1=$1
file2=$2

echo $file1 
echo $file2

if [ ! -e $file1 ]
then
	echo "$file1 not exist"
fi

if [ ! -e $file2 ]
then
	echo "$=ile2 not exist"
fi

outputFile=`basename $file1`

#创建文件夹
outputPath=liboutput

if [ ! -e $outputPath ]
then
	echo "mkdir -p $outputPath"
	mkdir -p $outputPath
fi


Architectures=(i386 armv7 x86_64 arm64)

for archive in ${Architectures[@]}
do
	if [ -e $outputPath/$archive ]
	then
		echo "rm -rf ${outputPath}/${archive}"
		rm -rf ${outputPath}/${archive}
	fi

	echo "mkdir -p $archive"
	mkdir -p ${outputPath}/${archive}	
	
	echo "mkdir -p $archive/1"
	mkdir -p "${outputPath}/${archive}/1"

	echo "mkdir -p $archive/2"
	mkdir -p "${outputPath}/$archive/2"

	tmpDir1=$outputPath/$archive/1
	tmpDir2=$outputPath/$archive/2

	echo "lipo -thin $archive $file1 -output $tmpDir1/$outputFile"
	`lipo -thin $archive $file1 -output $tmpDir1/$outputFile`
	echo "lipo -thin $archive $file2 -output $tmpDir2/$outputFile"
	`lipo -thin $archive $file2 -output $tmpDir2/$outputFile`

	cd $tmpDir1
	echo "ar -x $outputFile"
	ar -x $outputFile

	cd - 
	cd $tmpDir2
	echo "ar -x $outputFile"
	ar -x $outputFile

	cd - 
	cp -n $tmpDir2/*.o $tmpDir1/

	# 这里有个bug找不到原因
	# 两个库不能简单的用一个覆盖另一个，同名文件,有的用七牛的，有的用云信的（没出现同一个文件用哪个都不行的情况）, 手动拷贝这些文件，手动生产.a没问题，用脚本各种不行。
	# 默认文件1是七牛的
#	cd $tmpDir2
#	#两个库的.o文件没办法直接合并到一起，需要单纯处理一下几个文件
#	if [ "$outputFile" = "libcrypto.a" ] 
#	then
#		echo "cp evp_enc.o hmac.o stack.o digest.o cryptlib.o x509_vfy.o lhash.o evp_lib.o x509_lu.o x509cset.o ../1"
#		cp evp_enc.o hmac.o stack.o digest.o cryptlib.o x509_vfy.o lhash.o evp_lib.o x509_lu.o x509cset.o ../1
#	fi
#
#	if [ "$outputFile" = "libssl.a" ] 
#	then
#		echo "cp tls_srp.o ssl_lib.o ssl_cert.o d1_lib.o t1_enc.o ssl_ciph.o ../1"
#		cp tls_srp.o ssl_lib.o ssl_cert.o d1_lib.o t1_enc.o ssl_ciph.o ../1
#	fi
#
#	cd -
	ar -q $outputPath/$archive/$outputFile $tmpDir1/*.o

	objsPath=$objsPath" "$outputPath/$archive/$outputFile
done

echo "lipo $objsPath -create -output $outputPath/$outputFile"
#`lipo $objsPath -create -output $outputPath/$outputFile`

#cp $outputPath/$outputFile /Users/mac/work/HN-Nniu/HN-Nniu/HN-Nniu/LaunchServices/Yunxin/NIMKit/Vendors/NIMSDK/Libs/
