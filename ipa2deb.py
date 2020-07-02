# -*- coding: utf-8 -*-

import plistlib
import sys
import os
import shutil
import zipfile
#import deb_pkg_tools
#from deb_pkg_tools import package
#import fakechroot

infoPlistPath = ""
applicationPath = ""

jailbreakPath = "/Users/liu/work/source"

#读取plist文件
def getInfoFromPlist(filePath):
    fp = open(filePath, 'rb')
    dic = plistlib.load(fp, fmt=None)
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
    if os.path.exists('test.deb'):
        os.remove('test.deb')

    #package.build_package(path,'test.deb',check_package=False)
    shellcmd = 'dpkg-deb -b ' + path + ' test.deb'
    os.system(shellcmd) 
#    shutil.rmtree(path)

    updateJailbreakSource("test.deb")

#解析ipa
def parseIPA(filePath):
    if not os.path.exists(filePath):
        print('ipa 文件不存在')
    
    tmpPath = "tmp"
    if os.path.exists(tmpPath):
        shutil.rmtree(tmpPath)

    os.mkdir(tmpPath)

    shutil.copyfile(filePath, tmpPath + "/tmp.zip")

    #中文乱码问题
    zip_ref = zipfile.ZipFile(tmpPath + "/tmp.zip", 'r')
    with zipfile.ZipFile(tmpPath + "/tmp.zip", 'r') as zip_ref:
        for name in zip_ref.namelist():
            utf8name = name.encode('cp437').decode()
            utf8name = tmpPath + "/" + utf8name
            pathname = os.path.dirname(utf8name)
            if not os.path.exists(pathname) and pathname != "":
                os.makedirs(pathname)
            data = zip_ref.read(name)
            if not os.path.exists(utf8name):
                fo = open(utf8name, "wb+")
                fo.write(data)
                fo.close
        zip_ref.close()
        
    Payload = tmpPath + "/Payload"

    global applicationPath
    global infoPlistPath

    for filename in os.listdir(Payload):
        applicationPath = os.path.join(Payload,filename)

    infoPlistPath = applicationPath + "/Info.plist"
    creatDeb()

    shutil.rmtree(tmpPath)

#更新越狱源
def updateJailbreakSource(debFile):
    os.chdir(jailbreakPath)
    shutil.move(debFile, "test1.deb")

    if os.path.exists('Packages.bz2'):
        os.remove('Packages.bz2')

    #Packages Filename路径可能要修改，服务器根路径的相对路径
    cmd = 'dpkg-scanpackages test1.deb > Packages && bzip2 Packages -k'
    os.system(cmd)


def entry():
    parseIPA(sys.argv[1])

entry()
