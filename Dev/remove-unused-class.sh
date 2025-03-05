# 利用 Proguard 处理结果(Proguard 可以在编译时把未使用的类不放入classes.dex中)来删除无用的 java 类.
# 使用脚本前, 执行assembleLetvRelease任务来编译, Proguard 扫描到的未使用的类(也包括类成员)列表会写入 usage.txt.
# 注意: 编译前, 还要删除混淆规则文件中的 "-keep class * implements java.io.Serializable{*;}", 这样可以防止 Proguard 保留不再使用的 bean 类.
# Usage: remove-unused-class [-n] <project root path>(e.g., tv-app-desktop) <classes's package prefix> (e.g., com.stv) [<class excluding pattern>]
#   <pattern of excluded class>  pattern should use regexp, class which name matches this pattern will not be removed
#   -n  dry run, only list unused class, do not delete file.

while [ "${1:0:1}" == "-" ]; do
    if [ "$1" == "-n" ]; then
        dryRunFlag="on"
    fi
    shift
done

if [ $# -lt 1 ]; then
    echo "Usage: remove-unused-class [-n] <project root path> <classes's package prefix>(e.g., com.stv) [<<pattern of excluded class>]"
    exit 1
fi

JAVA_SRC_ROOT=src/main/java
projectRootPath=$1
if [ $# -ge 3 ]; then
  excludingPattern=$3
fi
if [ $# -ge 2 ]; then
  classPackagePrefix=$2
else
  classPackagePrefix="com"
fi
proguardUsageOutputFile=$projectRootPath/../tv-deskplatform/build/outputs/mapping/letvRelease/usage.txt

unusedClass=$(egrep "^${classPackagePrefix}\..+[^:]$" $proguardUsageOutputFile | egrep -v '\$.+$' | sort | uniq)
for class in $unusedClass ; do
  fullClassName=$JAVA_SRC_ROOT/${class//./\/}
  className=${fullClassName##*/}
  if [[ $excludingPattern && $className =~ $excludingPattern ]]
  then
    echo "Excluding class $fullClassName..."
    continue
  fi
  echo "Remove $fullClassName..."

  if [ "$dryRunFlag" != "on" ]; then
    javaFilePath=$projectRootPath/${fullClassName}.java
    ktFilePath=$projectRootPath/${fullClassName}.kt

    if [ -f $javaFilePath ]; then
      rm -f $javaFilePath
    elif [ -f $ktFilePath ]; then
      rm -f $ktFilePath
    else
      echo "!! file not exist"
    fi
  fi
done
