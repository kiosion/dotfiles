#!/bin/bash

# Set some vars
# Set year, month, day vars
curDate="$(date +"%Y-%m-%d")"
curDateY="$(date +"%Y")"
curDateM="$(date +"%m")"
curDateD="$(date +"%d")"

# Help func 
Help()
{
    echo "Backup directories to a .tar.gz archive."
    echo
    echo "Usage:"
    echo "  backup.sh [OPTION]... -S [SOURCE DIR]... -D [DESTINATION DIR]..."
    echo
    echo "Options:"
    echo "  -h      Display this help and exit"
    echo "  -o      Disable compression"
    echo "  -e      Encrypt archive with GPG"
    echo "  -u      Upload archive to remote backup share (requires -e)" 
    echo "  -n      No-confirm (no confirmation before backup or upload)"
    echo
    echo "Example:"
    echo "  To backup /home/user/backup to /home/user/backup/backup.tar.gz, encrypt, then upload:"
    echo "  backup.sh -eu -S /home/user/ -D /mnt/backupdrive/backup/"
    echo
}

# Print func
Print()
{
    echo "=> ${1}"
}

# Error func
Error()
{
    dialog --backtitle "Backup 0.0.2" --title "Error" --msgbox "${1}" 8 50
}

# Alert func
Alert()
{
    dialog --backtitle "Backup 0.0.2" --title "Alert" --msgbox "${1}" 8 50
}

# Load func
Load()
{
    while :; do
		dialog --backtitle "Backup 0.0.2" --title "Loading" --infobox "${1}" 8 50
		sleep 0.5
		dialog --backtitle "Backup 0.0.2" --title "Loading" --infobox "${1}." 8 50
		sleep 0.5
		dialog --backtitle "Backup 0.0.2" --title "Loading" --infobox "${1}.." 8 50
		sleep 0.5
		dialog --backtitle "Backup 0.0.2" --title "Loading" --infobox "${1}..." 8 50
		sleep 0.5
	done
}

# Transfer func
Transfer()
{
    Load "Transferring archive to local backup share" &
    loadpid=$!
    local source="${1}"
    local destination="/mnt/volta/backups/archives/${curDateY}-${curDateM}"
    # Get basename of source + file extension
    local fileExt="${source##*.}"
    local file="$(basename "${source}").${fileExt}"
    # Check file doesn't exist and dir does
    if [ -d "${destination}/${file}" ]; then
        kill "$loadpid"
        Error "Destination file already exists!"
        wait
        # Confirm overwrite
        if [ "${confirm}" = true ]; then
            dialog --backtitle "Backup 0.0.2" --title "Confirm overwrite" --yesno "Destination file already exists. Overwrite?" 8 60
            # Get exit status
            local response=$?
            case $response in
                0) # Overwrite
                    rm "${destination}/${file}"
                    break
                    ;;
                1) # No
                    Error "Cancelled"
                    wait
                    exit 1
                    ;;
                255) # Cancel
                    Error "Cancelled"
                    wait
                    exit 1
                    ;;
            esac
        fi
    fi
    if [ ! -d "${destination}/"  ]; then
        mkdir -p "${destination}/"
    fi
    # Use pv to copy file
    local filename=$(basename "${file}")
    kill "$loadpid"
    (pv "${source}" -n > "${destination}/${file}") 2>&1 | dialog --backtitle "Backup 0.0.2" --gauge "Transferring ${filename}" 10 60
    return 0
}

# Encrypt func
Encrypt() {
    # Set file to encrypt
    local file="${1}"
    # Check file exists
    if [ ! -f "${file}" ]; then
        Error "Cannot encrypt, file not found"
        return 1
    fi
    local filename=$(basename "${file}")
    # Encrypt file
    (pv -n < "${file}" | gpg --encrypt --sign --armor --recipient "hi@kio.dev" > "${file}.asc") 2>&1 | dialog --backtitle "Backup 0.0.2" --gauge "Encrypting ${filename}..." 10 60
    return 0
}

# Upload func
Upload()
{
    # Set file to upload
    local file="${1}"
    # Check file exists
    if [[ ! -f "${file}" ]]; then
        Error "Cannot upload, file not found"
        wait
        return 1
    fi
    # Get file name
    local filename=$(basename "${file}")
    # Check if file has space in it
    if [[ "${file}" =~ \ |\' ]]; then

        wait
        return 0
    else

    fi
    # Upload file with b2
    b2-linux upload_file "GalileoFiles" "${file}" "archives/${curDateY}-${curDateM}/${filename}" | cut -d ":" -f2 | cut -d "|" -f1 | sed 's/[^0-9]*//g' >&1 | dialog --backtitle "Backup 0.0.2" --gauge "Uploading ${filename} using B2..." 10 60
    wait
    return 0
}

# Proccess input
PASSED_ARGS=$@
transfer=false
compression=true
encrypt=false
upload=false
confirm=true
if [[ ${#PASSED_ARGS} -ne 0 ]]; then
    while getopts "htoreunS:D:" option; do
        case $option in
            h) # help
                Help
                exit 0
                ;;
            t) # transfer
                transfer=true
                ;;
            o) # no compression
                compression=false
                ;;
            e) # encrypt
                encrypt=true
                ;;
            u) # upload to remote share
                upload=true
                ;;
            n) # no-confirm
                confirm=false
                ;;
            S) # source
                srcDir=$OPTARG
                ;;
            D) # destination
                dstDir=$OPTARG
                ;;
            \?) # invalid
                Error "Invalid argument. Pass -h for help"
                wait
                clear
                exit 1
                ;;
        esac
    done
else
    Help
    exit 1
fi

# Check vars
if [ -z "${srcDir}" ]; then
    Error "Must provide source directory"
    wait
    clear
    exit 1
fi
if [ -z "${dstDir}" ]; then
    Error "Must provide destination directory"
    wait
    clear
    exit 1
fi
if [ "${upload}" = true ]; then
    if [ "${encrypt}" = false ]; then
        Error "Encryption required for upload!"
        wait
        clear
        exit 1
    fi
fi

# Remove trailing slash from dirs
srcDir=$(sed -e 's#/$##' <<< $srcDir)
dstDir=$(sed -e 's#/$##' <<<$dstDir)
# If path contains spaces that need to be escaped, escape them
# srcDir=$(sed -e 's# #\ #g' <<< $srcDir)
# dstDir=$(sed -e 's# #\ "#g' <<< $dstDir)
# If path contains escaped spaces, unescape them
srcDir=$(sed -e 's#\ # #g' <<< $srcDir)
dstDir=$(sed -e 's#\ # #g' <<< $dstDir)
# Set filename
fn=$(sed -e 's/\//-/g' <<< $srcDir)
fn=$(sed -e 's/~/ /g' <<< $fn)

# Check directories are valid
if [[ ! -d $srcDir ]]; then
    Error "Source directory \"${srcDir}\" is invalid"
    clear
    exit 1
fi
if [[ ! -d $dstDir ]]; then
    Error "Destination directory \"${dstDir}\" is invalid"
    clear
    exit 1
fi

# Ensure file doesn't already exist
if [[ -f "${dstDir}/${curDateY}-${curDateM}/${curDate}${fn}.tar.gz" ]]; then
    # Confirm overwrite
    if [ "${confirm}" = true ]; then
        dialog --backtitle "Backup 0.0.2" --title "Confirm overwrite" --yesno "Destination file already exists. Overwrite?" 8 60
        # Get exit status
        response=$?
        case $response in
            0) # Overwrite
                # Remove file
                rm "${dstDir}/${curDateY}-${curDateM}/${curDate}${fn}.tar.gz" && break
                ;;
            1) # No
                clear && exit 1;;
            255) # Cancel
                clear && exit 1;;
        esac
    fi
fi

# Create dir if doesn't exist
if [[ ! -d "${dstDir}/${curDateY}-${curDateM}/" ]]; then
    mkdir -p "${dstDir}/${curDateY}-${curDateM}/"
fi
cd "${dstDir}/${curDateY}-${curDateM}/"

# Set source size
Load "Calculating directory size" &
loadpid=$!
size_source=`du -sb --exclude=.cache --exclude=.vscode/* --exclude=.local/share/Trash "$srcDir" 2>/dev/null | awk '{print $1}'`
size_source_gb=`echo ${size_source} | awk '{print $1/1000/1000/1000}'`
kill "$loadpid"
clear

# If confirm is true
if [ "${confirm}" = true ]; then
    dialog --backtitle "Backup 0.0.2" --title "Confirm archive" --yesno "Total to archive: ${size_source_gb} GB. Continue?" 8 60
    # Get exit status
    response=$?
    case $response in
        0) # Overwrite
            clear
            ;;
        1) # No
            clear && exit 0
            ;;
        255) # Cancel
            clear && exit 0
            ;;
    esac
fi

# Run tar cmd
if [ "$compression" = false ]; then
    tar cf - --ignore-failed-read -P --exclude=/home/$(whoami)/.vscode --exclude=/home/$(whoami)/.cache --exclude=/home/$(whoami)/.local/share/Trash "${srcDir}" | (pv -s ${size_source} -n > "${curDate}${fn}.tar") 2>&1 | dialog --backtitle "Backup 0.0.2" --gauge "Archiving with Tar..." 10 60
    fileLoc="${dstDir}/${curDateY}-${curDateM}/${curDate}${fn}.tar"
else
    tar cf - --ignore-failed-read -P --exclude=/home/$(whoami)/.vscode --exclude=/home/$(whoami)/.cache --exclude=/home/$(whoami)/.local/share/Trash "${srcDir}" | (pv -s ${size_source} -n | gzip > "${curDate}${fn}.tar.gz") 2>&1 | dialog --backtitle "Backup 0.0.2" --gauge "Archiving with Tar & Gzip..." 10 60
    #sleep 6
    fileLoc="${dstDir}/${curDateY}-${curDateM}/${curDate}${fn}.tar.gz"
fi

#exit 0

# Encrypt
if [ "${encrypt}" = true ]; then
    Encrypt "${fileLoc}"
    wait
    Load "Removing original archive" &
    loadpid=$!
    rm "${fileLoc}"
    # Set new file loc
    fileLoc="${fileLoc}.asc"
    kill "$loadpid"
fi

# Set archive size
Load "Calculating archive size" &
loadpid=$!
size_source=`du -sb ${fileLoc} 2>/dev/null | awk '{print $1}'`
size_source_gb=`echo ${size_source} | awk '{print $1/1000/1000/1000}'`
kill "$loadpid"
clear

# Upload
if [ "${upload}" = true ]; then
    # Check encryption
    if [ "${encrypt}" != true ]; then
        Error "Encryption required for upload"
        clear && exit 1
    fi
    # If size is > 10GB, confirm upload
    if [ ${size_source_gb} > 10 ]; then
        # If no-confirm is false
        if [ "${confirm}" = true ]; then
            dialog --backtitle "Backup 0.0.2" --title "Confirm upload" --yesno "Total to upload: ${size_source_gb} GB. Continue?" 8 60
            wait
            # Get exit status
            response=$?
            case $response in
                0) # Overwrite
                    clear
                    ;;
                1) # No
                    clear
                    exit 0
                    ;;
                255) # Cancel
                    clear
                    exit 0
                    ;;
            esac
        fi
    fi
    Upload "${fileLoc}"
    wait
    clear
    # Remove .asc file if upload was successful
    Load "Removing .asc file" &
    loadpid=$!
    rm "${fileLoc}"
    kill "$loadpid"
fi

# Transfer
if [ "$transfer" = true ]; then
    Transfer "${dstDir}" "${curDateY}-${curDateM}" "${curDate}${fn}.tar.gz"
    wait
    Load "Removing archive" &
    loadpid=$!
    rm "${dstDir}/${curDateY}-${curDateM}/${curDate}${fn}.tar.gz"
    # Set new file loc
    fileLoc="/mnt/volta/backups/archives/${curDateY}-${curDateM}/${curDate}${fn}.tar.gz"
    kill "$loadpid"
fi

Alert "Backup complete"
wait
clear

exit 0
