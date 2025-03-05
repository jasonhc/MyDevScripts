# Usage: ./la-sp-change.sh <xml name> <element type> <element name> <new value>

if [ $# -lt 4 ]; then
    echo "Usage: $0 <xml name> <element name> <new value> <element type>"
    exit 1
fi

PACKAGE_NAME="com.stv.deskplatform"
DATA_DIR="/data/data"

${0%/*}/sp-change ${PACKAGE_NAME} ${DATA_DIR} $*
