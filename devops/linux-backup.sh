#!/usr/bin/env bash

# Linux Restore
# 需要安装 # yum install sshpass # apt install sshpass

# 备份设备
targetIP=$1   # 目标设备
backupFile=$2 # 待还原的系统包
password=$3   # 设备密码

# 备份完存储本机的目录
backupDir="/data/jenkins-audit/backup"
targetBackupFileDir="/root/restore"

echo -e "targetIP=$targetIP ,backupFile=$backupFile"

ping -c1 $targetIP

if (($? != 0)); then
    echo "Ping $targetIP Fail!"
    exit
fi

backupFilePath=$backupDir/$backupFile
if [ ! -f "$backupFilePath" ]; then
    echo -e "$backupFilePath 不存在!"
    exit
fi

if [[ "$password" == "" ]]; then
    echo "passowrd not set"
    exit
fi

# 远程执行
# 删除以前恢复
sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP "rm -fr $targetBackupFileDir"

echo -e "start mkdir $targetBackupFileDir ..."
mkdirCmd="mkdir $targetBackupFileDir"
echo -e "$mkdirCmd"

sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP $mkdirCmd
echo -e "mkdir done!"

# 拷贝到本地
echo -e "start copy $backupFilePath to ${targetIP}:$targetBackupFileDir ..."
sshpass -p "$password" scp $backupFilePath root@${targetIP}:$targetBackupFileDir
echo -e "copy done"

# 远程执行还原
remoteBackupFile="$targetBackupFileDir/$backupFile"
echo -e "start restore $backupFile ..."
restoreCmd="sudo tar -xvpzf $remoteBackupFile -C / --numeric-owner"
echo -e "$restoreCmd"

sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP $restoreCmd
echo -e "restore done!"

# 修改网卡信息
modifyNetCardShellName="modify-netcard.sh"
modifyNetCardShell=$(dirname "$0")/tools/$modifyNetCardShellName
targetDeviceShellDir="/tmp"

ls -l $modifyNetCardShell

if (($? != 0)); then
    echo "$modifyNetCardShell file not exist! Error!"
    exit
fi

# 拷贝到本地
echo -e "start copy $modifyNetCardShell to ${targetIP}:$targetDeviceShellDir ..."
sshpass -p "$password" scp $modifyNetCardShell root@${targetIP}:$targetDeviceShellDir
echo -e "copy done"

echo -e "start modify netcard info..."
netcardCmd="sh $targetDeviceShellDir/$modifyNetCardShellName"
echo -e "$netcardCmd"

sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP $netcardCmd
echo -e "modify netcard done!"

# 删除备份文件
echo -e "rm -fr $targetIP >> $targetBackupFileDir"
sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP "rm -fr $targetBackupFileDir"
echo -e "rm done"
