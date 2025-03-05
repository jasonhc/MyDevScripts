#!/bin/bash

# 指定生成文件的数量和大小（单位为字节）
num_files=500
file_path=/data/data/com.stv.deskplatform/

# 循环生成文件
for ((i=1; i<=$num_files; i++)); do
  adb shell mkdir $file_path/file_$i
done

echo "$num_files 个目录已创建"

