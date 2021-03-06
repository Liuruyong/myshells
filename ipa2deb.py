# -*- coding: utf-8 -*-

import plistlib
import sys
import os
import shutil
import re

infoPlistPath = ""
applicationPath = ""
appname = ""

jailbreakPath = "/Users/liu/work/source"

#读取plist文件
def getInfoFromPlist(filePath):
    fp = open(filePath, 'rb')
    dic = plistlib.load(fp, fmt=None)
    global appname
    appname = dic["CFBundleDisplayName"]
    bundleid = dic["CFBundleIdentifier"]
    appversion = dic["CFBundleShortVersionString"]
    minimumOSVersion = dic["MinimumOSVersion"]
    return (appname,bundleid,appversion,minimumOSVersion)

#更新control文件
def updateControlFile(path):
    appname, bundleid, appversion, minimumOSVersion = getInfoFromPlist(infoPlistPath)
    
    fp = open(path, 'w')
    fp.writelines([
        "Package:"+bundleid+"\n",
        "Name:"+appname+"\n",
        "Version:" + appversion + "\n",
        "Description:test \n",
        "Section:阅读\n",
        "Depends:firmware(>=" + minimumOSVersion + ")\n",
        "Priority:optional\n",
        "Architecture: iphoneos-arm\n",
        "Author: wandu\n",
        "Homepage:https://www.exchen.net\n",
        "Icon:file:///Applications/test.app/Icon.png\n",
        "Maintainer:wandu\n",
    ])
    fp.close()

#生成目录
def creatDeb():
    path = "./debtest"
    if os.path.exists(path):
        shutil.rmtree(path)
       
    os.mkdir(path)
    os.mkdir(path + "/DEBIAN")
    os.mkdir(path + "/Applications")
    controlFile = path + "/DEBIAN" + "/control" 
    fp = open(controlFile,'w+')
    fp.close()
    updateControlFile(controlFile)

    #拷贝文件夹
    shutil.move(applicationPath,path + "/Applications")

    #生成deb包
    if os.path.exists('tmp.deb'):
        os.remove('tmp.deb')

    #package.build_package(path,'test.deb',check_package=False)
    shellcmd = 'dpkg-deb -b ' + path + ' tmp.deb'
    os.system(shellcmd) 
    shutil.rmtree(path)

    global appname
    updateJailbreakSource("tmp.deb",appname)

#解析ipa
def parseIPA(filePath):
    if not os.path.exists(filePath):
        print('ipa 文件不存在')
    
    tmpPath = "tmp"
    if os.path.exists(tmpPath):
        shutil.rmtree(tmpPath)

    os.mkdir(tmpPath)

    shutil.copyfile(filePath, tmpPath + "/tmp.zip")

    #python解压后，程序不能执行，通过shell解压
    os.chdir(tmpPath)
    cmd = 'unzip tmp.zip'
    os.system(cmd)
    os.chdir('..')
    Payload = tmpPath + "/Payload"

    global applicationPath
    global infoPlistPath

    for filename in os.listdir(Payload):
        applicationPath = os.path.join(Payload,filename)

    infoPlistPath = applicationPath + "/Info.plist"
    creatDeb()

    shutil.rmtree(tmpPath)

#更新越狱源
def updateJailbreakSource(debFile,appname):
    os.chdir(jailbreakPath)
    targetFile = appname + ".deb"

    if os.path.exists(targetFile):
        os.remove(targetFile)

    if os.path.exists('Packages.bz2'):
        os.remove('Packages.bz2')

    shutil.move(debFile, targetFile)

    #Packages Filename路径可能要修改，服务器根路径的相对路径
    cmd = 'dpkg-scanpackages -m -t deb . > Packages'
    os.system(cmd)

    #服务器路径替换
    f = open('Packages', 'r')
    alllines = f.readlines()
    f.close()
    f = open('Packages', 'w+')
    for eachline in alllines:
        a = re.sub(jailbreakPath, '', eachline)
        f.writelines(a)
    f.close()

    cmd = 'bzip2 Packages -k' 
    os.system(cmd) 


def entry():
    parseIPA(sys.argv[1])

entry()
