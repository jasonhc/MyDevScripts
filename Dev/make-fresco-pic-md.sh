#!/bin/bash

# 把Fresco加载图片的log转换为markdown文本格式: 每一行中的时间(不包括日期)作为文本(文本字号要大一些)直接放在markdown中, 图片链接作为一个图片放在markdown中.
# Fresco的log格式如下:
# 12-05 10:56:56.051 D/FrescoDBG( 2050): ControllableEcoImageView, setImage, uri: 'http://i0.letvimg.com/lc04_iscms/202310/30/17/33/d4f3ac13780b4a77a4d20911a3fcde44.jpg.webp', image tag: 'null'
# 11-04 10:47:02.339  2039  3925 V EcoBitmap:BufferedDiskCache: Disk cache read for http://i0.img.cp21.ott.cibntv.net/lc18_iscms/202411/01/17/53/fec95850237a4eb5aeb00aa64d253d21.jpg.webp
# 11-04 10:47:02.120  2039  3925 V EcoBitmap:BufferedDiskCache: Successful read from disk cache for http://i2.img.cp21.ott.cibntv.net/lc18_iscms/202410/31/18/14/a21fc8b9980347cca1ed05d7e5191c9f.jpg.webp
# Usage: make-fresco-pic-md <log file> <output markdown>

if [ $# -lt 2 ]; then
    echo "Usage: make-fresco-pic-md <log file> <output markdown>"
    exit 1
fi

input_file=$1
output_file=$2

# Create or clear the output file
> "$output_file"

# Function to append time and image URL to the markdown file
append_to_markdown() {
  local time=$1
  local url=$2
  local message=$3
  echo "## $time - $message" >> "$output_file"
  echo "![]($url)" >> "$output_file"
  echo "" >> "$output_file"
}

# Read the log file line by line
while IFS= read -r line
do
  # Extract the time and image URL using regex
  if [[ $line =~ ([0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3})\ .*ControllableEcoImageView,\ setImage,\ uri:\ \'(http.*)\', ]]; then
    append_to_markdown "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "Image loaded"
  elif [[ $line =~ ([0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3})\ .*Disk\ cache\ read\ for\ (http.*) ]]; then
    append_to_markdown "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "Disk cache read"
  elif [[ $line =~ ([0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3})\ .*Successful\ read\ from\ disk\ cache\ for\ (http.*) ]]; then
    append_to_markdown "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "Successful read from disk cache"
  fi
done < "$input_file"