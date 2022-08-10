#!/usr/bin/env bash
source a.sh

aa=""

getData
echo $aa

outputDir="/data/jenkins-audit/outputs/2022-07-28_22-20-30"
outDirParentPath=$(dirname $outputDir)
outDirName=$(basename $outputDir)

echo "$outDirName"
echo "$outDirParentPath"
