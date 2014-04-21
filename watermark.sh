#!/bin/bash
#WATERMARK="$HOME/Pictures/watermark/watermark.jpg"
IMGFILES=`find $i -name "*.jpg"`

: ${1?"Usage: $0 Path to watermark"}

for each in ${IMGFILES}
  do
  echo "Working on "$each" ..."
  #composite -gravity southwest -dissolve 15 $1 "$each" "$each" >> /dev/null
  composite -gravity southwest $1 "$each" "$each" >> /dev/null
  echo "... Done!"
 done
exit 0
