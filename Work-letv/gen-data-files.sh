#!/bin/bash

# 指定生成文件的数量和大小（单位为字节）
num_files=5000
#num_files=5
file_size=1024  # 1KB
file_path=/data/data/com.stv.deskplatform/files/

# 循环生成文件
for ((i=1; i<=$num_files; i++)); do
    adb push login-account.sh "$file_path/file_$i.txt"
    # adb shell busybox dd if=/dev/zero of="$file_path/file_$i.txt" bs=$file_size count=1 
done

echo "$num_files 个文件已生成"

