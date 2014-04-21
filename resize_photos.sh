#!/bin/bash

# this script will simple resize photos in current directory
# to a RESIZED folder.
# You can do either (for 640 pixel width)
#	resize-photos.sh 640	
# or just (and use the included WIDTH variable)
#	resize-photos.sh
#
# DEPENDS: imagemagick


# Configruation

# folder where the resized images goto
RESIZED=./resized

WIDTH=1024

# if you don't want to strip EXIF information then use 
# STRIP=''
STRIP='-strip'

# $1 should be a number bigger than 0
if [[ -n "$1" && "$1" -gt 0 ]]; then
                WIDTH=$1
                echo "Using Width = $1"
        else
                echo -e "No suitable value provided,\nresizing images to ${WIDTH} pixels (width)"
fi

# create folder for resized images
mkdir -p ${RESIZED}

for IMAGE in *.jpg;
        do
                convert ${STRIP} -resize ${WIDTH} ${IMAGE} ${RESIZED}/${IMAGE}
                echo "resized ${IMAGE}";
done

