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

# Transfer func
Transfer()
{
# Check file doesn't exist and dir does
if [ -d "/mnt/volta/backups/Devices/Galileo/${2}/${3}" ]; then
    echo "=> Error: File already exists!"
    return 1
fi
if [ ! -d "/mnt/volta/backups/Devices/Galileo/${2}/"  ]; then
    echo "=> Creating directory..."
    mkdir -p "/mnt/volta/backups/Devices/Galileo/${2}/"
fi
# Use pv to copy file
clear
echo
pv "${1}/${2}/${3}" > "/mnt/volta/backups/Devices/Galileo/${2}/${3}"
echo "=> Done!"
sleep 1
return 0
}

# Proccess input
PASSED_ARGS=$@
if [[ ${#PASSED_ARGS} -ne 0 ]]
then
    while getopts ":s:d:h" option; do
        case $option in
            h) # help
                Help
                exit
                ;;
            s) # source
                srcDir=$OPTARG;;
            d) # destination
                dstDir=$OPTARG;;
            :) # no arg given
                echo "=> No arguments provided: Pass -h for help"
                exit
                ;;
            \?) # invalid
                echo "=> Invalid argument: Pass -h for help"
                exit
                ;;
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
# Set year, month, day vars
curDate="$(date +"%Y-%m-%d")"
curDateY="$(date +"%Y")"
curDateM="$(date +"%m")"
curDateD="$(date +"%d")"
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
if [ -d "${dstDir}/${curDateY}/${curDateM}/${curDate}-${fn}.tar.gz" ]; then
    echo "=> Error: Destination file already exists!"
    exit 1
fi

# Create dir if doesn't exist
if [ ! -d "${dstDir}/${curDateY}/${curDateM}/" ]; then
    echo "=> Creating directory for backup..."
    mkdir -p "${dstDir}/${curDateY}/${curDateM}/"
fi
cd "${dstDir}/${curDateY}/${curDateM}/"

# Set source size
echo "=> Calculating size..."
Load &
size_source=`du -sb --exclude=.cache --exclude=.vscode/* --exclude=.local/share/Trash --exclude=Nextcloud ${srcDir} 2>/dev/null | awk '{print $1}'`
size_source_gb=`echo $size_source | awk '{print $1/1000/1000/1000}'`
StopLoad
clear
echo
echo "=> Total to backup: $size_source_gb GB"
# Confirm
while true
do
    read -r -p "=> Continue? [Y/n] " input
    case $input in
        [nN])
            exit 0
            ;;
        [yY])
            break
            ;;
        *)
            break
            ;;
    esac
done
# Use tar to create archive
echo "=> Starting backup with tar..."
sleep 1
clear

# Run tar cmd
echo
tput civis
tar cf - --ignore-failed-read -P --exclude=/home/kio/.vscode --exclude=/home/kio/.cache --exclude=/home/kio/.local/share/Trash --exclude=Nextcloud ${srcDir} | pv -s ${size_source} | gzip > ${curDate}-${fn}.tar.gz
tput cnorm

# When finished
echo
echo "=> Archive creation complete!"
while true
do
    read -r -p "=> Transfer to backup share? [Y/n] " input
    case $input in
        [nN])
            break
            ;;
        *)
            Transfer "${dstDir}" "${curDateY}/${curDateM}" "${curDate}-${fn}.tar.gz"
            clear
            echo
            while true
            do
                read -r -p "=> Remove source archive? [y/N] " inputDel
                case $inputDel in
                    [yY])
                        rm "${dstDir}/${curDateY}/${curDateM}/${curDate}-${fn}.tar.gz"
                        echo "=> Source archive removed!"
                        break
                        ;;
                    *)
                        break
                        ;;
                esac
            done
            break
            ;;
    esac
done

exit 0
