# Usage: change-xxx <desktop id1> <desktop id2>...

#dryRun="echo"

toolPath=${0%/*}
mockDataDir=~/work/launcher/launcher-src/mock-http-data/test-http-cache/
mockDataFnamePrefix="tv_template_%1_desktop_get"
mockDataOrgTemplate="$mockDataFnamePrefix.org.json"
mockDataNewTemplate="$mockDataFnamePrefix.new.json"
tmpMockData="mock_data_tmp.json"

function changeDesktopMockData() {
  desktopId=$1
  mockDataOrg=${mockDataOrgTemplate/\%1/$desktopId}
  mockDataNew=${mockDataNewTemplate/\%1/$desktopId}
  $dryRun mv $mockDataDir/$mockDataOrg $mockDataDir/$tmpMockData
  $dryRun mv $mockDataDir/$mockDataNew $mockDataDir/$mockDataOrg
  $dryRun mv $mockDataDir/$tmpMockData $mockDataDir/$mockDataNew

  $dryRun $toolPath/../mock-http-data.sh $mockDataDir/$mockDataOrg
}

function showCurrentMockData() {
  mockDataVideoOrgFile=${mockDataOrgTemplate/\%1/video}
  echo "Current mock data of video desktop..."
  fgrep "披荆斩棘的哥哥" $mockDataDir/$mockDataVideoOrgFile

  mockDataTeleplayOrgFile=${mockDataOrgTemplate/\%1/teleplay}
  echo "Current mock data of teleplay desktop..."
  fgrep "肖申克" $mockDataDir/$mockDataTeleplayOrgFile
}

if [ $# -lt 1 ]; then
  echo "Usage: change-xxx <desktop id1> <desktop id2>..."
  exit 1
fi

for desktop in $@; do
  changeDesktopMockData $desktop
done

showCurrentMockData
