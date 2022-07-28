#!/usr/bin/env bash
currPath=$(readlink -f .)

echo -e "Audit手动更新安装包"

CP="/bin/cp -fr"
TargetOriginPath="/opt/netvine/origin"
TargetPath="/opt/audit"

# 更新web
webPath=$currPath/web
if [ ! -d "$webPath" ]; then
    echo "$webPath 目录不存在!"
fi

webTargetPath=$TargetPath/frontend
rm -fr $webTargetPath/*
$CP $webPath/* $webTargetPath/

supervisorctl restart audit-web

# 更新server
serverPath=$currPath/server
if [ ! -d "$serverPath" ]; then
    echo "$serverPath 目录不存在!"
fi

serverTargetPath=$TargetPath/backend
rm -fr $serverTargetPath/*
$CP $serverPath/* $serverTargetPath/
$CP $serverPath/shell/* $serverTargetPath/
rm -fr $serverTargetPath/shell

supervisorctl restart audit-server

# 更新engine
enginePath=$currPath/engine
if [ ! -d "$enginePath" ]; then
    echo "$enginePath 目录不存在!"
fi

engineTargetPath=$TargetPath/ids
rm -fr $engineTargetPath/*
$CP $enginePath/* $engineTargetPath/

systemctl restart southwest_engine.service
