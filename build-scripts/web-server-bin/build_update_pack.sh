#!/usr/bin/env bash

# 构建Audit升级包

source $(dirname "$0")/config/config.sh
source $(dirname "$0")/git/git_utils.sh
source $(dirname "$0")/build/build_soft.sh

echo -e "\e[33mAudit Build Update Package \033[0m"

# 选择要制作升级包的版本
TargetPackageDir=$1

TargetBuildPackagePath=$(find $JenkinsRootDir -name $TargetPackageDir -type d)

if [[ "${TargetBuildPackagePath}" == "" ]]; then
    echo -e "Error 升级包不存在!"
    exit
fi

# 替换名称audit_build_1.0.1_20220730_154634 => audit_update_1.0.1_20220730_154634
TargetPackageDir=${TargetPackageDir/build/update}

updatePackageStorePath="${JenkinsRootDir}/$PackagesOutputDir/update"
if [ ! -d "$updatePackageStorePath" ]; then
    mkdir -p $updatePackageStorePath
fi

updatePackDir=$updatePackageStorePath/$TargetPackageDir

# 删除之前制作的
rm -fr $updatePackDir

# 拷贝时，如果文件夹已经存在，拷贝失败
$CP $TargetBuildPackagePath $updatePackDir

if (("$?" != 0)); then
    echo -e "Error 拷贝编译包 $TargetBuildPackagePath 失败!"
    exit
fi

$CP $updatePackDir/backend/resource/version_info.conf $updatePackDir
rm -fr $updatePackDir/manualUpdateSoft.sh

# 打包
cd $updatePackageStorePath
tarFileName=${TargetPackageDir}.tar.gz

# 删除之前制作的
rm -fr $tarFileName

tar -zcvf $tarFileName $TargetPackageDir

if (("$?" != 0)); then
    echo -e "Error tar打包失败!"
    exit
fi

# 计算md5
packMd5=$(md5sum $tarFileName | cut -d' ' -f1)

# 修改文件名称
finalTarName=${TargetPackageDir}_md5${packMd5}.tar.gz
mv $tarFileName $finalTarName

echo "-------------Audit Build Update Package Complete!-------------"
echo "升级包文件:$updatePackageStorePath/$finalTarName"
