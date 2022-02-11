#!/bin/bash

clear
# Set path for backup location
cwd="/mnt/kepler/Archives/"
cd "${cwd}"
# Set date
curDate="$(date +"%d-%m-%Y")"
# Set dir to backup
bkDir="/home/kio/"

# Ensure file doesn't already exist
if [ -f "${cwd}homeBackup/home-backup.tar.gz" ]; then
    echo ""
    echo "=> Error: File already exists! Aborting..."
    exit 1
fi

# Create dir if doesn't exist
if [ -d "${cwd}homeBackup/" ]; then
    echo ""
    echo "=> Creating directory for backup..."
    mkdir -p "${cwd}homeBackup/"
    cd "${cwd}homeBackup/"
    sleep 1
fi

# Set source size
size_source=`du -sb --exclude=.cache --exclude=.vscode/* --exclude=.local/share/Trash --exclude=Nextcloud /home/kio/ 2>/dev/null | awk '{print $1}'`
size_source_gb=`echo $size_source | awk '{print $1/1000/1000/1000}'`
echo "=> Total to backup: $size_source_gb GB"
sleep 1

# Use tar to create archive
echo "=> Starting backup with tar..."
sleep 1
clear

# Run tar cmd
echo ""
tar cf - --ignore-failed-read -P --exclude=/home/kio/.cache --exclude=/home/kio/.local/share/Trash --exclude=Nextcloud /home/kio/ | pv -s ${size_source} | gzip > home-backup.tar.gz

# When finished creating archive
clear
echo ""
echo "=> Archive creation complete!"
sleep 1

# Create directory on backup share
remoteCwd="/mnt/volta/backups/Devices/Galileo/"
echo ""
echo "=> Creating destination directory..."
if [ -d "${remoteCwd}${curDate}/" ]; then
    echo ""
    echo "=> Destination directory exists, skipping..."
fi
if [ ! -d "${remoteCwd}${curDate}/" ]; then
echo "=> Creating destination directory..."
    mkdir -P ${remoteCwd}${curDate}/
    echo ""
    echo "=> Destination directory created!"
fi
sleep 1
clear

# Copy file to backup SMB share
echo ""
echo "=> Preparing to copy archive with rsync..."

# Set source size
size_source=`du -bs ${cwd}homeBackup/ | sed -r "s/^[^0-9]*([0-9]+).*$/\1/"`
size_source_gb=`echo $size_source | awk '{print $1/1000/1000/1000}'`
echo "=> Total to copy: $size_source_gb GB"
sleep 1
clear
# Run rsync cmd
rsync -rtDq --stats --ignore-errors ${cwd}homeBackup/home-backup.tar.gz ${remoteCwd}${curDate}/home-backup.tar.gz | pv -s ${size_source}

clear
# Show progress
#while [[ `jobs | grep "rsync"` ]]; do
#    size_target=`du -bs $cwd/$curDate$bkDir 2>/dev/null | sed -r "s/^[^0-9]*([0-9]+).*$/\1/"`
#    size_target_gb=`echo $size_target | awk '{print $1/1000/1000/1000}'`
#    calc_done=`expr 100 \* $size_target / $size_source`
#    echo "$"
#done
echo ""
echo "=> Done!"
exit 0
