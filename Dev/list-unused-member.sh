# 列出未使用的方法和类成员
# Usage: list-xxx <classes's package prefix> (e.g., com.stv)

if [ $# -lt 1 ]; then
  echo "Usage: list-xxx <classes's package prefix> (e.g., com.stv)"
  exit 1
fi

PROGUARD_USAGE_FILE_PATH=~/work/launcher/launcher-src/tv-deskplatform/build/outputs/mapping/letvRelease/usage.txt
classPackagePrefix=$1

# 在结果中去除类常量, 构造方法, 这两类成员一般不需要删除
sed -En "/^${classPackagePrefix}\..+:$/,/^[a-z]/p" $PROGUARD_USAGE_FILE_PATH | egrep -v "static final |<init>\(|^[a-z].+[^:]$"
