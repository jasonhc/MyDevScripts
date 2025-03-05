#!/usr/bin/env bash

# Usage: get-desktop-data [-test] <desktop name> [<device model>]
#   -test, output data for test env; output data for MangoTV if "-test" option not specified
#   <desktop name>: e.g., video, movie
#   <device model>: e.g., X5-55, default is X5-55
# output data of desktop's main page to standard output.

# dryRun="echo"

while [ "${1:0:1}" == "-" ]; do
    if [ "$1" == "-test" ]; then
        testFlag="on"
    fi
    shift
done

if [ $# -lt 1 ]; then
    echo "Usage: get-desktop-data [-test] <desktop name> [<device model>] [<device mac>]"
    echo "  <desktop name>: e.g., video, movie"
    echo "  <device model>: e.g., X5-55, default is X5-55"
    exit 1
fi

declare -A pageIdMap=(["teleplay"]="2000010453"  ["movie"]="2000010457"  ["variety"]="2000010472"  ["combine"]="2000010454"  ["courseshop"]="2000010467"  ["comic"]="2000010492"  ["kids"]="2000010493"  ["mgtv"]="2000010490"  ["pptv"]="2000010496"  ["school"]="2000010551"  ["documentary"]="2000010557"  ["kugou"]="2000010567"  ["holiday"]="2000010630"  ["changba"]="2000010622"  ["video"]="2000010631"  ["app"]="2000010623"  ["game"]="2000010624"  ["cloudgame"]="2000010684"  ["health"]="2000010686"  ["iqiyi"]="2000010537" ["squaredance"]="2000010853" ["video2"]="2000010841")

DESKTOP_NAME_PREFIX="tv_template_"
BROADCAST_ID="4"
desktopId=$1
deviceModel=$2
deviceMac=$3

if [ "$deviceModel" == "" ]; then
    deviceModel="X5-55"
fi

if [ "$deviceMac" == "" ]; then
    deviceMac="B01BD2768B3B"
fi

if [ $testFlag ]; then
    dcDomain="103.52.174.221"
    extraParameter="-H Host:api-oeco-itv-letv.yysh.mgtv.com"
else
    dcDomain="api-oeco-itv-letv.yysh.mgtv.com"
    extraParameter=""
fi

CURL_CMD="curl -s -k \
              $extraParameter https://${dcDomain}/proxy/api/common/desktop/get.json?pageid=${pageIdMap[$desktopId]}&splatid=1009&salesArea=CN&terminalApplication=${DESKTOP_NAME_PREFIX}${desktopId}&appCode=2024082015&token=103XXXp1xQP9m18lrScCesjCPGcom2VBBIJczTGm2qaL1P2oywWVtPWkq8uzom2D2ySJABDm3qV9fJm3OOhwkkQZ3O67i7GFsm2CbF1YDk2b8low4YIhGDLMm4&userId=&mac=${deviceMac}&ph=420007%2C-121&bsChannel=cibn&userFlag=${deviceMac}&from=tv_super15&displayPlatformId=301&appVersion=3.0.1&src=1%2C2&terminalBrand=letv&displayAppId=120&client=android&deviceKey=&terminalSeries=${deviceModel}&p_devType=1&broadcastId=${BROADCAST_ID}&langcode=zh_cn"
if [ $dryRun ]; then
  echo $CURL_CMD
else
  $CURL_CMD | jq .
fi
