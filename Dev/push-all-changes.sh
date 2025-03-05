#!/usr/local/bin/bash

# Usage: push-all-changes, 把3个 Project 的改动 push 到 dev 分支, 执行脚本时的当前目录没有要求

#dryRun="echo"
source ~/tools/launcher-scripts-env.sh

declare -A pushMap=(["tv-deskplatform"]="platform-dev" ["tv-template-desktop"]="template-dev" ["tv-desktop-library"]="lib-dev")

for project in ${!pushMap[@]}; do
  echo
  echo "### Push changes of project: $project"
  echo
  $dryRun cd $projectRootPath/$project
  $dryRun $gpush ${pushMap[$project]}
done