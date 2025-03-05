# 检查 Launcher 应用动态配置下发的数据: 1. json 格式是否正确; 2. 输出某项数据的值, 人工检查值内容
# check-launcher-dynamic-config [-test] <key of item to check> <Launcher version>...
#   "-test": show config of test environment, default is mgtv and cibn
#   <key of item to check>: e.g., "desktopShowOrder"
#   <Launcher version>: e.g., "2.9.0.2103"
# V1: first worked version
# V2: use 'jq' to validate whole json
# V3: use 'jq' to output an item's value
# V4: can also check data on test server 101.236.15.24
# V5: add flag "-test"; simplify parameter "item key"

if [ $# -lt 2 ]; then
  echo "Usage: check-launcher-dynamic-config [-test] <key of item to check> <Launcher version>..."
  exit 1
fi

function checkVersion() {
  version=$1
  broadcaster=$2
  itemKey=$3

  if [ "$broadcaster" == "cibn" ]; then
    dcDomain="api-oeco-itv.cp21.ott.cibntv.net"
  elif [ "$broadcaster" == "mgtv" ]; then
    dcDomain="api-oeco-itv-letv.yysh.mgtv.com"
  else
    dcDomain="101.236.15.24"
    extraParameter="-H Host:api-oeco-itv.cp21.ott.cibntv.net"
  fi

  echo
  echo "## check version: $version, $broadcaster"
  jsonText=$(curl -s $extraParameter "http://$dcDomain/iptv/api/new/terminal/config.json?versionName=$version&salesArea=CN&temrinalUiVersion=&\
countryArea=&terminalApplication=tv_deskplatform&terminalBrand=media&terminalUi=&terminalSeries=X4-50N&bsChannel=cibn&\
broadcastId=&devId=B01BD2543210&model=1")
  if jq -e . >/dev/null <<<"$jsonText"; then
    echo "  json text is OK"
  fi
  echo $jsonText | jq "..|.${itemKey}?" | egrep -v "^null$"
}

while [ "${1:0:1}" == "-" ]; do
    if [ "$1" == "-test" ]; then
        testFlag="on"
    fi
    shift
done

ITEM_KEY_PREFIX_OF_SERVER=".data.configInfo"
itemKey=$1
shift 1

for version in $@ ; do
  if [ $testFlag ]; then
    checkVersion $version test $itemKey
  else
    checkVersion $version cibn $itemKey
    checkVersion $version mgtv $itemKey
  fi
done
