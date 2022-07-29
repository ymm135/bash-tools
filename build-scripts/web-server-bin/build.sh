#!/usr/bin/env bash

source config/config.sh
source git/git_utils.sh
source build/build_soft.sh

echo -e "\e[33mAudit Soft Update \033[0m"

RootDir=$(readlink -f .)
GlobalOutputDir=""

# 下载构建脚本
buildRepoName="build-scripts"
buildScriptGitRepo="${GitUrl}:web/${buildRepoName}.git"

# 更新编译脚本
buildCodePath="${JenkinsRootDir}/$buildRepoName"

downloadCode $buildScriptGitRepo $JenkinsRootDir $buildCodePath

updateCode $buildCodePath master

downloadAndUpdateAuditCode $JenkinsRootDir

cd $RootDir
# 拷贝更新脚本并打包
echo "输出目标路径$GlobalOutputDir"
$CP $RootDir/update/manualUpdateSoft.sh $GlobalOutputDir

outDirName=$(basename $GlobalOutputDir)
outDirParentPath=$(dirname $GlobalOutputDir)

# 打包
cd $outDirParentPath
tarFileName=${outDirName}.tar.gz
tar -zcvf $tarFileName $outDirName

# 需要免密，拷贝安装包到目标设备，并安装
targetDeviceDir="/data/update_packages"
versionFile="/opt/audit/backend/resource/version_info.conf"
updateSoftScript="$RootDir/remote/update_soft.sh"
for ip in "$@"; do
    echo "安装更新到${ip} ..."
    ssh root@${ip} "mkdir $targetDeviceDir"
    scp $outDirParentPath/$tarFileName root@${ip}:$targetDeviceDir
    ssh root@${ip} "cd $targetDeviceDir ; tar -zxvf $tarFileName ; cd $outDirName ; sh manualUpdateSoft.sh"
    echo -e "升级软件到:\n$(ssh root@${ip} cat "$versionFile")"
done

echo "-------------Audit Build Complete!-------------"
echo "打包文件:$tarFileName"
