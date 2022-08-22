#!/usr/bin/env bash

# Linux BackUP
# 需要安装 # yum install sshpass # apt install sshpass

# 备份设备
targetIP=$1
password=$2

ping -c1 $targetIP

if (($? != 0)); then
    echo "Ping $targetIP Fail!"
    exit
fi

if [[ "$password" == "" ]]; then
    echo "passowrd not set"
    exit
fi

# 存放备份文件的目录
targetDeviceStoreBackupDir="/root/backup"

# 要备份的目录 /
targetDeviceBackupDir="/"

# 备份完存储本机的目录
backupDir="/data/jenkins-audit/backup"

# 备份文件名
backupFile="audit_backup_$(date '+%Y%m%d-%H%M%S').tar.gz"

echo -e "targetIP=$targetIP"

if [ ! -d "$backupDir" ]; then
    mkdir -p $backupDir
fi

# yum install sshpass
# 删除以前备份
ssh-keygen -R $targetIP
sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP "rm -fr $targetDeviceStoreBackupDir"

# 远程执行
echo -e "start tar $backupFile ..."
backUpCmd="mkdir $targetDeviceStoreBackupDir;cd $targetDeviceStoreBackupDir; sudo tar -cvpzf $backupFile $targetDeviceBackupDir --exclude=$backupFile --exclude=/lost+found --exclude=/proc --exclude=/mnt --exclude=/etc/fstab --exclude=/sys --exclude=/dev --exclude=/boot --exclude=/tmp --exclude=/var/cache/apt/archives --exclude=/run --warning=no-file-changed"
echo -e "$backUpCmd"

ssh-keygen -R $targetIP
sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP $backUpCmd
echo -e "tar done!"

backupFilePath="$targetDeviceStoreBackupDir/$backupFile"
# 拷贝到本地
ssh-keygen -R $targetIP
echo -e "start copy $backupFile to $backupDir ..."
sshpass -p "$password" scp root@${targetIP}:$backupFilePath $backupDir
echo -e "copy done"

ssh-keygen -R $targetIP
echo -e "rm -fr $targetIP >> $targetDeviceStoreBackupDir"
sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@$targetIP "rm -fr $targetDeviceStoreBackupDir"
echo -e "rm done"
