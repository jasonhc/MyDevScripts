
# v2: add option "-test", dump 测试环境的数据
# v1: first version

# Usage: dump-xxx [-test] <output dir> <version1> <version2> ...
#   -test, output data for test env; output data for MangoTV if "-test" option not specified
#   <version>, version name of Launcher app, <version>+<release date>, e.g., 3.0.2.2112

#dryRun=echo

ITEM_KEY_PREFIX_OF_SERVER=".data.configInfo"

function dumpVersion() {
  local version=$1
  local broadcaster=$2

  if [ "$broadcaster" == "cibn" ]; then
    dcDomain="api-oeco-itv.cp21.ott.cibntv.net"
    broadcastId="2"
  elif [ "$broadcaster" == "mgtv" ]; then
    dcDomain="api-oeco-itv-letv.yysh.mgtv.com"
    broadcastId="4"
  else
    dcDomain="103.52.174.221"
    broadcastId="4"
    extraParameter="-H Host:api-oeco-itv.cp21.ott.cibntv.net"
  fi

  echo "Dump version: $version to file \"$outputDir/launcher-dynamic-config-$version-$broadcaster.json\"..."
  echo "http://$dcDomain/iptv/api/new/terminal/config.json?versionName=$version&salesArea=CN&temrinalUiVersion=&\
countryArea=&terminalApplication=tv_deskplatform&terminalBrand=media&terminalUi=&terminalSeries=X4-50N&bsChannel=cibn&\
broadcastId=$broadcastId&devId=B01BD2543210&model=1"
  curl -s $extraParameter "http://$dcDomain/iptv/api/new/terminal/config.json?versionName=$version&salesArea=CN&temrinalUiVersion=&\
countryArea=&terminalApplication=tv_deskplatform&terminalBrand=media&terminalUi=&terminalSeries=X4-50N&bsChannel=cibn&\
broadcastId=$broadcastId&devId=B01BD2543210&model=1" | jq "$ITEM_KEY_PREFIX_OF_SERVER" > $outputDir/launcher-dynamic-config-$version-$broadcaster.json
}

while [ "${1:0:1}" == "-" ]; do
    if [ "$1" == "-test" ]; then
        testFlag="on"
    fi
    shift
done

if [ $# -lt 2 ]; then
    echo "Usage: dump-xxx [-test] <output dir> <version1> <version2> ... "
    exit 1
fi

outputDir=$1
shift

test -d "$outputDir" || mkdir -p "$outputDir"

for version in $@ ; do
  if [ $testFlag ]; then
    dumpVersion $version test
  else
#    dumpVersion $version cibn
    dumpVersion $version mgtv
  fi
done
