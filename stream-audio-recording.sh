#!/bin/sh
#
# This script allows you to record an audio stream using the "at"
# command and cvlc (vlc w/o GUI).
# You can record only one stream at a time, because we have to kill all vlc instances to stop the recording.

# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 0. You just DO WHAT THE FUCK YOU WANT TO.

########################################################################
# specify default destination folder here:
DEFAULT_DEST_FOLDER="$HOME/recordings/"

# specify your favourite stream URL:
DEFAULT_URL="http://www.dradio.de/streaming/dkultur_hq_ogg.m3u"

# specify your default compression, always ogg, 1: 192kb/s, 2: 128kb/s
DEFAULT_COMPRESSION=2

########################################################################
# INPUT
echo "=== Program your recording ==="

# choose a stream
echo "=== Please enter a stream URL.
default: ${DEFAULT_URL}"
read url
: ${url:=$DEFAULT_URL}

# choose destination folder
echo "=== Where do you want your file to be saved, enter a folder name:
default: ${DEFAULT_DEST_FOLDER}"
read folder
: ${folder:=$DEFAULT_DEST_FOLDER}

# test if the folder exists
if test ! -d $folder
then
    echo "The folder does not exist: $folder"
    echo "Create it? (y/N)"
    read makefolder
    : ${makefolder:="n"}

    # otherwise make it
    if [ "$makefolder" = "y" ]; then
	mkdir -p $DEFAULT_DEST_FOLDER
    fi
fi

# filename
file="$folder/`date +"%Y-%m-%d_%H-%M"`.ogg"
echo "
=== Your file will be saved as: $file ===
"

# choose start time
echo "=== start recording at: (for example: 15:35)
(default: now)"
read startrecording
: ${startrecording:='now'}

#choose stop time
echo "=== stop recording at (for example: 17:00)"
read stoprecording

# go!
# make sure atd is running
echo "=== Starting the at-daemon:"
sudo /etc/init.d/atd start

# choose a compression level
echo "=== Please choose a compression level:
 1 - bitrate : 192k/s "
  [ x$DEFAULT_COMPRESSION = x"1" ] && echo -n "(default) \n"
echo -n "
 2 - bitrate 128k "
  [ x$DEFAULT_COMPRESSION = x"2" ] && echo -n "(default)"

read compressionlevel
: ${compressionlevel:=$DEFAULT_COMPRESSION}

case $compressionlevel in
	1) echo "/usr/bin/cvlc $url --intf=dummy ':sout=#transcode{vcodec=none,acodec=vorb,ab=192,channels=2}:std{access=file,mux=ogg,url=$file,select=no-video}}':sout-all" | at $startrecording;;
	2) echo "/usr/bin/cvlc $url --intf=dummy ':sout=#transcode{vcodec=none,acodec=vorb,ab=128,channels=2}:std{access=file,mux=ogg,url=$file,select=no-video}}':sout-all" | at $startrecording;;
esac

# stop recording & terminate script
echo killall cvlc | at $stoprecording
exit 0

echo "=== Your recording has been programmed. ==="

