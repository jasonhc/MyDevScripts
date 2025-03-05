
# compare a json file (which has only one line, not formatted) of 2 commits
# Usage: gdjson <commit 1> <commit 2> <json file path>

if [ $# -lt 3 ]; then
    echo "Usage: gdjson <commit 1> <commit 2> <json file path>"
    exit 1
fi

commit1=$1
commit2=$2
jsonFile=$3
TMP_DIR=~/work/tmp/

git show $commit1:$jsonFile | jq . > $TMP_DIR/1.json
git show $commit2:$jsonFile | jq . > $TMP_DIR/2.json

diff -b -u $TMP_DIR/1.json $TMP_DIR/2.json
#diff -u $TMP_DIR/1.json $TMP_DIR/2.json
