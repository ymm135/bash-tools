#!/usr/bin/env bash

# 下载代码
downloadCode() {
    gitUrl=$1    # 第一个参数是git地址
    targetDir=$2 # 第二个参数是目标路径
    repoDir=$3   # 第二个参数是目标路径

    if [ ! -d "$targetDir" ]; then
        mkdir -p $targetDir
    fi

    if [ -d $repoDir ]; then
        echo -e "downloadCode 仓库$repoDir 已存在,无需下载!"
        return
    fi

    echo -e "downloadCode 下载仓库$gitUrl 目标路径为$targetDir"

    cd $targetDir
    git clone $gitUrl
    cd -
}

updateCode() {
    targetDir=$1 # 第二个参数是目标路径
    branch=$2    # 代码分支

    if [ ! -d "$targetDir" ]; then
        echo -e “downloadCode \033[31m 无法更新代码, $targetDir 不存在! \033[0m”
        exit
    fi

    cd $targetDir
    git fetch
    git add .
    git reset --hard origin/$branch
}
