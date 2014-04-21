#!/bin/sh

###################################################
# Update multiple wordpress installations via FTP #
#-------------------------------------------------#
# chmod to 700, chown to root:root as passwords   #
# are stored in cleartext                         #
# lftp just overwrites files, but you may change  #
# this behaviour, just read the manual            #
# page for lftp for more options                  #
# (ie. -n for uploading only files that are newer)#
###################################################

LATEST="http://wordpress.org/latest.tar.gz"
LATEST_FILENAME="latest.tar.gz"
LATEST_DIR="wordpress"
WORK_DIR="/tmp"

FTPCONFIG=(
		# user:pass@host
		[0]="user:pass@ftp.server1.com"
		[1]="user:pass@ftp.server2.com"
)
FTPBASEDIR=(
		# directory on server
		[0]="/wordpress/"
		[1]="/"
)
FTPNAME=(
		# name of your ftpsite
		[0]="SERVER 1"
		[1]="SERVER 2"
)

# Let's start downloading the latest wordpress release
cd $WORK_DIR
wget $LATEST
tar -xvzf $LATEST_FILENAME
cd $LATEST_DIR
# i don't like to upload the themes all the time
rm -rf 'wp_content/themes/'

# we test only the height of FTPCONFIG, supposing you have the same height on FTPBASEDIR
height=${#FTPCONFIG[@]}

# now upload to all sites
for ((i=0;i<$height;i++))
do
    lftp ${FTPCONFIG[$i]} -e "mirror -R -n . ${FTPBASEDIR[$i]} ; quit"
    echo "Transfer finished for ${FTPNAME[$i]}"
done

# Delete temporary files
cd $WORK_DIR
rm -rf $WORK_DIR/$LATEST_DIR $WORK_DIR/$LATEST_FILENAME
echo "Temporary files successfully removed"

echo "Update finished"

exit 0
