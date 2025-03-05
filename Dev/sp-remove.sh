
if [ $# -lt 4 ]; then
    echo "Usage: $0 <package name> <data dir> <xml name> <element name1> <element name2>..."
    exit 1
fi

#dry_run=echo
TEMP_DIR=~/tmp

PACKAGE_NAME="$1"
DATA_DIR="$2"
shift 2

# 命令行参数
# 添加.xml后缀到文件名
file_name="$1.xml"
shift
element_names=$*

local_xml_file=${TEMP_DIR}/${file_name}

# 使用adb pull从Android设备上获取SharedPreference文件
$dry_run adb pull "${DATA_DIR}/${PACKAGE_NAME}/shared_prefs/${file_name}" ${local_xml_file}

for name in ${element_names}; do
    # 使用xmlstarlet删除元素
    $dry_run xmlstarlet ed --inplace --delete "//*[@name='${name}']" "${local_xml_file}"
done

# 使用adb push将修改后的文件推送回Android设备
$dry_run adb push ${local_xml_file} "${DATA_DIR}/${PACKAGE_NAME}/shared_prefs/${file_name}"
