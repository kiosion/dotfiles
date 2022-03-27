#!/bin/bash

# Help func 
Help()
{
echo
echo "Syntax: backup.sh -h, -s <source>, -d <dest>"
echo
}

# Load func
Load()
{
tput civis
chars="/-\|"
while :; do
    for (( i=0; i<${#chars}; i++ )); do
        sleep 0.1
        echo -en "${chars:$i:1}" "\r"
    done
done
}
StopLoad()
{
kill "$!"
tput cnorm
}

# Proccess input
PASSED_ARGS=$@
if [[ ${#PASSED_ARGS} -ne 0 ]]
then
    while getopts ":s:d:h" option; do
        case $option in
            h) # help
                Help
                exit;;
            s) # source
                srcDir=$OPTARG;;
            d) # destination
                dstDir=$OPTARG;;
            :) # no arg given
                echo "=> No arguments provided: Pass -h for help"
                exit;;
            \?) # invalid
                echo "=> Invalid argument: Pass -h for help"
                exit;;
        esac
    done
else
    Help
    exit 1
fi

# If vars are empty
if [[ -z "$srcDir" ]]
then
    echo "=> Missing required argument: -s"
    exit 1
fi

if [[ -z "$dstDir" ]]
then
    echo "=> Missing required argument: -d"
    exit 1
fi

echo "=> Source to backup: $srcDir"
echo "=> Destination directory: $dstDir"
# Set date
curDate="$(date +"%d-%m-%Y")"
# Remove trailing slash from dirs
srcDir=$(sed -e 's#/$##' <<< $srcDir)
dstDir=$(sed -e 's#/$##' <<<$dstDir)
# Set filename
fn=$(sed -e 's#^.*/##' <<< $srcDir)

# Check directories are valid
if [ ! -d "$srcDir" ]; then
    echo
    echo "Error: Source directory is invalid!"
    echo
    exit 1
fi
if [ ! -d "$dstDir" ]; then
    echo
    echo "Error: Destination directory is invalid!"
    echo
    exit 1
fi

# Ensure file doesn't already exist
if [ -d "${dstDir}/${curDate}/${fn}.tar.gz" ]; then
    echo "=> Error: Destination already exists!"
    exit 1
fi

# Create dir if doesn't exist
if [ ! -d "${dstDir}/${curDate}/" ]; then
    echo "=> Creating directory for backup..."
    mkdir -p "${dstDir}/${curDate}/"
    cd "${dstDir}/${curDate}/"
fi

# Set source size
echo "=> Calculating size..."
Load &
size_source=`du -sb --exclude=.cache --exclude=.vscode/* --exclude=.local/share/Trash --exclude=Nextcloud ${srcDir} 2>/dev/null | awk '{print $1}'`
size_source_gb=`echo $size_source | awk '{print $1/1000/1000/1000}'`
StopLoad
echo "=> Total to backup: $size_source_gb GB"

# Use tar to create archive
echo "=> Starting backup with tar..."
sleep 1
clear

# Run tar cmd
echo
tar cf - --ignore-failed-read -P --exclude=/home/kio/.vscode --exclude=/home/kio/.cache --exclude=/home/kio/.local/share/Trash --exclude=Nextcloud ${srcDir} | pv -s ${size_source} | gzip > ${fn}.tar.gz

# When finished
echo
echo "=> Archive creation complete!"
echo
exit 0
