source $(dirname "$0")/config/config.sh
source $(dirname "$0")/git/git_utils.sh

echo -e "\e[33mAudit Updata Build Script \033[0m"

# 下载构建脚本
buildRepoName="build-scripts"
buildScriptGitRepo="${GitUrl}:web/${buildRepoName}.git"

# 更新编译脚本
buildCodePath="${JenkinsRootDir}/$buildRepoName"

downloadCode $buildScriptGitRepo $JenkinsRootDir $buildCodePath

updateCode $buildCodePath master
