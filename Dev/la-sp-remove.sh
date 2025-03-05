# Usage: ./la-sp-remove.sh <xml name> <element name>

if [ $# -lt 2 ]; then
    echo "Usage: $0 <xml name> <element name1> <element name2>..."
    exit 1
fi

PACKAGE_NAME="com.stv.deskplatform"
DATA_DIR="/data/data"

${0%/*}/sp-remove ${PACKAGE_NAME} ${DATA_DIR} $*
# ${0%/*}/sp-remove.sh ${PACKAGE_NAME} ${DATA_DIR} $*
