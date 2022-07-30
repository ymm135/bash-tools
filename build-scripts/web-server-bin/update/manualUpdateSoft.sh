#!/usr/bin/env bash
currPath=$(readlink -f .)

echo -e "Audit手动更新安装包"

CP="/bin/cp -fr"
TargetOriginPath="/opt/netvine/origin"
TargetPath="/opt/audit"

# 更新web
webDirName="frontend"
webPath=$currPath/$webDirName
if [ ! -d "$webPath" ]; then
    echo "$webPath 目录不存在!"
fi

webTargetPath=$TargetPath/$webDirName
rm -fr $webTargetPath/*
$CP $webPath/* $webTargetPath

supervisorctl restart audit-web

# 更新server
serverDirName="backend"
serverPath=$currPath/$serverDirName
if [ ! -d "$serverPath" ]; then
    echo "$serverPath 目录不存在!"
fi

serverTargetPath=$TargetPath/$serverDirName
rm -fr $serverTargetPath/*
$CP $serverPath/* $serverTargetPath
$CP $serverPath/shell/a.sh $serverTargetPath/

dataAudit="/data/audit"
if [ ! -d "$dataAudit" ]; then
    mkdir -p dataAudit
fi

# 存放设备目录
deviceInfo="device_info.conf"
if [ ! -f "$dataAudit/deviceInfo" ]; then
    $CP $serverPath/resource/$deviceInfo $dataAudit
fi

supervisorctl restart audit-server

# 更新engine
engineDirName="ids"
enginePath=$currPath/$engineDirName
if [ ! -d "$enginePath" ]; then
    echo "$enginePath 目录不存在!"
fi

engineTargetPath=$TargetPath/$engineDirName
rm -fr $engineTargetPath/*
$CP $enginePath/* $engineTargetPath

systemctl restart southwest_engine.service
