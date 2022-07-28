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

cd $outDirParentPath
tarFileName=${outDirName}.tar.gz
tar -zcvf $tarFileName $outDirName

echo "-------------Audit Build Complete!-------------"
echo "打包文件:$tarFileName"
