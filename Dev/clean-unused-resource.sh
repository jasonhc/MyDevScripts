# Clean unused resource files list in lint report xml
# 执行脚本前, 先用如下命令进行 lint 检查 (在某个 Project 的根目录下执行该命令): "gradlew lint".
# 在 build.gradle 中加上如下配置, 只检查"未使用的资源":
#      lintOptions {
#        check 'UnusedResources'
#    }
# 因为 lint report xml 里的文件路径为绝对路径, 所以该脚本可以在任何目录下运行.
# Usage: xxx <lint report xml>

if [ $# -lt 1 ]; then
    echo "Usage: xxx <lint report xml>"
    exit 1
fi

lintReportXml=$1

dirs="anim layout drawable raw"
unusedFiles=$(sed -En 's|[[:space:]]+file="(.+)"(/>)?|\1|p' $lintReportXml)
for file in $unusedFiles; do
  for dir in ${dirs[@]}; do
    if [[ $file =~ res/$dir ]]; then
      #       echo "Handle file $file"
      if [ -f $file ]; then
        echo "Delete file $file ..."
        rm $file
      else
        echo "!!! File $file not found"
      fi
    fi
  done
done
