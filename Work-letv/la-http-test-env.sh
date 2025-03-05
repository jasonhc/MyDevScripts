#!/usr/local/bin/bash

# Usage: xxx <http url>

function constructTestHostMap() {
  hostConfigFile=$1
  while read line; do
    hostPair=($line)
    testHostMap["${hostPair[1]}"]="${hostPair[0]}"
#    echo "test host: ${hostPair[1]} -> ${hostPair[0]}"
  done <$hostConfigFile
}

if [ $# -lt 1 ]; then
    echo "Usage: xxx <http url>"
    exit 1
fi

#dryRun=echo

PROJECT_ROOT_PATH=~/work/launcher/launcher-src/
url=$1
declare -A testHostMap

constructTestHostMap ${PROJECT_ROOT_PATH}/script/test-hosts-config.txt
if [[ "$url" =~ https?://([^/]+)/.+ ]]; then
#  echo "url match"
  host=${BASH_REMATCH[1]}
  if [ ${testHostMap[$host]} ]; then
#    echo "test host: ${testHostMap[$host]}"
    testUrl=${url/$host/${testHostMap[$host]}}
  else
    testUrl=$url
  fi
else
  testUrl=$url
fi

hostParam="-H Host:$host"
curlCmd="curl -s -k $hostParam $testUrl"
if [ $dryRun ]; then
  echo $curlCmd
else
  $curlCmd
fi
