#!/usr/bin/env bash

source $RootDir/config/config.sh

# 编译审计项目软件
webAndServerRepoName="audit"
webAndServerRepoBranch=develop

engineRepoName="southwest_engine"
engineRepoBranch=develop

webDir="web"
serverDir="server"

webAndServerGitRepo="${GitUrl}:web-audit/${webAndServerRepoName}.git"
engineGitRepo="${GitUrl}:audit/${engineRepoName}.git"

downloadAndUpdateAuditCode() {
    echo -e "downloadAndUpdateAuditCode downloadAndUpdateAuditCode"

    downloadCode $webAndServerGitRepo $JenkinsRootDir ${JenkinsRootDir}/$webAndServerRepoName
    updateCode ${JenkinsRootDir}/$webAndServerRepoName $webAndServerRepoBranch

    downloadCode $engineGitRepo $RootDJenkinsRootDirir ${JenkinsRootDir}/$engineRepoName
    updateCode ${JenkinsRootDir}/$engineRepoName $engineRepoBranch

    echo -e "downloadAndUpdateAuditCode \e[93 更新审计项目代码成功 \033[0m"

    outputDir=${JenkinsRootDir}/outputs/audit-$(date '+%Y-%m-%d_%H-%M-%S')
    if [ ! -d "$outputDir" ]; then
        mkdir -p $outputDir
    fi

    buildAuditWeb ${JenkinsRootDir}/${webAndServerRepoName}/$webDir $outputDir
    buildAuditServer ${JenkinsRootDir}/${webAndServerRepoName}/$serverDir $outputDir
    buildAuditEngine ${JenkinsRootDir}/${engineRepoName} $outputDir

    GlobalOutputDir=$outputDir

    echo "outputDir=$outputDir"
    echo -e "downloadAndUpdateAuditCode complete!"
}

# 编译前端
buildAuditWeb() {
    dir=$1
    tartgetDir=$2

    if [ ! -d "$dir" ]; then
        echo "buildAuditWeb 目标路径不存在: $dir"
        exit
    fi

    cd $dir
    # 清除
    rm -rf node_modules/
    rm -fr dist/

    echo -e "\n buildAuditWeb npm install ..."

    npm install

    echo -e "\n buildAuditWeb npm build ..."
    npm run build

    distDir=$dir/dist
    if [ ! -d "$distDir" ]; then
        echo -e "\033[31m error $distDir 编译失败! \033[0m"
        exit
    fi

    webTargetDir=$tartgetDir/web
    mkdir -p $webTargetDir

    $CP $distDir/* $webTargetDir

    echo -e "\n buildAuditWeb complete! \n"
    cd -
}

# 编译后端
buildAuditServer() {
    echo -e "buildAuditServer"
    dir=$1
    tartgetDir=$2

    cd $dir

    if [ ! -d "$dir" ]; then
        echo "buildAuditServer 目标路径不存在: $dir"
        exit
    fi

    MAIN_FILE=$dir/main.go
    if [ ! -f "$MAIN_FILE" ]; then
        echo "Error $MAIN_FILE 文件存在在"
        exit
    fi

    # 执行编译
    SERVER_BIN="audit-server"
    rm -fr $SERVER_BIN

    go mod tidy

    go clean

    GOOS=linux GOARCH=amd64 go build -o audit-server -ldflags '-s -w'

    if [ ! -f $SERVER_BIN ]; then
        echo -e "\033[31m error $SERVER_BIN 编译失败! \033[0m"
        exit
    fi

    serverTartgetDir=$tartgetDir/server
    mkdir -p $serverTartgetDir

    $CP $SERVER_BIN $serverTartgetDir

    #拷贝脚本
    $CP $dir/shell $serverTartgetDir

    # 拷贝配置文件
    configArray=("config.yaml" "config-test.yaml")
    for config in ${configArray[@]}; do
        echo "拷贝配置文件$config 到 $target_dir $copyConfig"
        $CP $config $serverTartgetDir
    done

    echo -e "\n buildAuditServer complete! \n"
    cd -
}

# 编译引擎
buildAuditEngine() {
    echo -e "buildAuditEngine"
    dir=$1
    tartgetDir=$2

    cd $dir

    if [ ! -d "$dir" ]; then
        echo "buildAuditEngine 目标路径不存在: $dir"
        exit
    fi

    make clean

    make x86

    targetBin=$dir/src-3.0/southwest_engine
    if [ ! -f "$targetBin" ]; then
        echo "buildAuditEngine 目标文件不存在: $targetBin"
        exit
    fi

    engineTargetDir=$tartgetDir/engine
    mkdir -p $engineTargetDir/bin

    $CP $targetBin $engineTargetDir/bin

    engineFiles=("$dir/config" "$dir/3.0_rules")

    for item in ${engineFiles[@]}; do
        echo "拷贝 ${item}"
        $CP $item $engineTargetDir
    done

    echo -e "\n buildAuditEngine complete! \n"
    cd -
}
