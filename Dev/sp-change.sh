
if [ $# -lt 6 ]; then
    echo "Usage: $0 <package name> <data dir> <xml name> <element name> <new value> <element type>"
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
element_name=$2
new_value=$3
element_type=$4

local_xml_file=${TEMP_DIR}/${file_name}

# 使用adb pull从Android设备上获取SharedPreference文件
$dry_run adb pull "${DATA_DIR}/${PACKAGE_NAME}/shared_prefs/${file_name}" ${local_xml_file}
#cat $local_xml_file

# 修改值
# 检查是否存在该项
xmlstarlet_output=$(xmlstarlet sel -t -c "//${element_type}[@name='${element_name}']" "$local_xml_file")
#echo "output=$xmlstarlet_output"
if [ "$xmlstarlet_output" == ""  ]; then
    # 如果不存在，插入新项
    if [ "${element_type}" == "string" ]; then
#        value_exp="-n temp -v \"${new_value}\" -r //temp -v \"${element_type}\"
#                   -i \"/map/${element_type}[not(@name)][last()]\" -t attr -n name -v \"${element_name}\""
        value_exp="-v ${new_value}
                   -i //${element_type}[last()] -t attr -n name -v ${element_name}"
    else
#        value_exp="-n \"${element_type}\" -v \"\"
#                   -i \"//${element_type}[last()]\" -t attr -n name -v \"${element_name}\"
#                   -i \"//${element_type}[last()]\" -t attr -n value -v \"${new_value}\""
        value_exp="-i //${element_type}[last()] -t attr -n name -v ${element_name}
                   -i //${element_type}[last()] -t attr -n value -v ${new_value}"
    fi
#    $dry_run eval xmlstarlet ed --inplace -s "/map" -t elem -n \"${element_type}\" ${value_exp} "$local_xml_file"
    $dry_run xmlstarlet ed --inplace -s "/map" -t elem -n ${element_type} ${value_exp} "$local_xml_file"

    # 下面这种写法也可以, 但有些复杂
#    if [ "${element_type}" == "string" ]; then
#        value_exp="-n temp -v \"${new_value}\" -r //temp -v \"${element_type}\"
#                   -i \"/map/${element_type}[not(@name)][last()]\" -t attr -n name -v \"${element_name}\""
#    else
#        value_exp="-n \"${element_type}\" -v \"\"
#                   -i \"//${element_type}[last()]\" -t attr -n name -v \"${element_name}\"
#                   -i \"//${element_type}[last()]\" -t attr -n value -v \"${new_value}\""
#    fi
#    $dry_run eval xmlstarlet ed --inplace -s "/map" -t elem -n \"${element_type}\" ${value_exp} "$local_xml_file"
else
    # 如果存在，修改属性值
    if [ "${element_type}" == "string" ]; then
        value_exp=""
    else
        value_exp="/@value"
    fi
    $dry_run xmlstarlet ed --inplace -u "//${element_type}[@name='${element_name}']${value_exp}" \
        -v "$new_value" "$local_xml_file"
fi

# 使用adb push将修改后的文件推送回Android设备
#cat $local_xml_file
$dry_run adb push ${local_xml_file} "${DATA_DIR}/${PACKAGE_NAME}/shared_prefs/${file_name}"
