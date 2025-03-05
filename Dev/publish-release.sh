#!/usr/local/bin/bash

set -e

# Usage: xxx <release branch> <release_branches_describe_file> <last release branch>

function constructBranchesMap() {
  while read line; do
    branchPair=($line)
#    branchPair=(${line//,/ })
    releaseBranches["${branchPair[0]}"]="${branchPair[1]}"
  done <$releaseBranchesFile
}

function makeReleaseBranches() {
  # 建立 release 分支, 如果某个模块该分支在本地已存在, 则跳过不处理该模块
  for project in ${!releaseBranches[@]}; do
    echo
    echo "## project $project"
    $dryRun cd "$projectRootPath/$project"
    branch=${releaseBranches[$project]}
    if git rev-parse --verify $branch; then
        echo "Local branch $branch already exists, do not make release branch for this project"
        continue
    fi

    $dryRun git fetch origin
    $dryRun git checkout -b $branch origin/dev
    $dryRun git push origin $branch
  done
}

function makeReleaseManifest() {
  $dryRun cd $manifestPath
  $dryRun git fetch origin
  $dryRun git checkout origin/master

  manifestFileName=$release.xml
  manifestFile=$manifestPath/$manifestFileName
  manifestTemplateFile=$manifestPath/$lastRelease.xml
  echo cp $manifestTemplateFile $manifestFile
  $dryRun cp $manifestTemplateFile $manifestFile

  for project in ${!releaseBranches[@]}; do
    branch=${releaseBranches[$project]}
    $dryRun sed -E -i '' "/<project[[:space:]]+name=\"$project\"/ s/revision=\".+\"/revision=\"$branch\"/" $manifestFile
  done

  $dryRun git add $manifestFileName
  $dryRun git commit -m "桌面平台新版本 $release"
  $dryRun git push origin HEAD:refs/for/master
}

if [ $# -lt 3 ]; then
    echo "Usage: xxx <release branch> <release_branches_describe_file> <last release branch>"
    exit 1
fi

$dryRun test -f $2

projectRootPath=~/work/launcher/launcher-src/
release=$1
lastRelease=$3
releaseBranchesFile=$2
manifestPath=$projectRootPath/.repo/manifests/tp/terminal/tv_deskplatform
declare -A releaseBranches

#dryRun="echo"

constructBranchesMap
makeReleaseBranches
makeReleaseManifest
