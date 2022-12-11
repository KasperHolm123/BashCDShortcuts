#!/bin/bash

# declare internal container
declare -A shortcuts


function fill_array() {
    # reset internal container
    shortcuts=()

    # fill internal container with all shortcuts in container dir
    while read line; do 
        key=$(echo $line | cut -d "=" -f1)
        data=$(echo $line | cut -d "=" -f2)
        shortcuts[$key]="$data"
    done < ~/BashCDShortcuts/shortcuts.txt
}

# fill array with all shortcuts in container
if [ -e ~/BashCDShortcuts/ ]
then
    fill_array
fi

function cdproj () {
    unset opt OPTARG OPTIND # reset environment variables

    # only allow "-h" if the container dir doesn't exist
    if [ ! -e ~/BashCDShortcuts ] && [ $1 != "-h" ] && [ $1 != "-m" ]; then
        echo "Container directory missing. Use 'cdproj -m' to create it"
        return
    fi

    declare cdarg=$1
    if [ ${cdarg:0:1} != "-" ]; then
        changedir
        return
    fi

    while getopts "hlmpn:d:" option; do
        case $option in
            h) # help
                usage
                return;;
            l) # list all shortcuts
                listall
                return;;
            m) # create container dir
                makedir
                return;;
            p) # delete container dir
                purgedir
                return;;
            n) # create new shortcut
                newshortcut
                return;;
            d) # remove shortcut
                deleteshortcut
                return;;
            *) # default
                echo "Error: Invalid option"
                return;;
        esac
    done
}


usage() {
    echo "options:"
    echo "-l      Shows all available shortcuts"
    echo "-m      Creates shortcut container directory"
    echo "-d      Deletes shortcut container directory"
    echo "-c      Changes directory to the value of a shortcut"
    echo "-n      Creates a new shortcut"
    echo '  syntax  "KEY|PATH" include double quotes and "|"'
    echo "-r      Removes a shortcut"
}

listall() {
    echo "All shortcuts:"
    for x in "${!shortcuts[@]}"
    do
        echo "$x=${shortcuts[$x]}"
    done
}

makedir() {
    if [ -e ~/BashCDShortcuts ]; then
        echo "Container dir already exists"
        return
    fi
    mkdir ~/BashCDShortcuts
    echo "Created directory for container at ~/BachCDShortcuts"
    touch ~/BashCDShortcuts/shortcuts.txt
    echo "Created container for shortcuts at ~/BashCDShortcuts/shortcuts.txt"
    fill_array
}

purgedir() {
    rm -rf ~/BashCDShortcuts
    echo "Purged ~/BashCDShortcuts recursively"
}

newshortcut() {
    echo "$OPTARG" >> ~/BashCDShortcuts/shortcuts.txt
    fill_array
}

deleteshortcut() {
    echo "$OPTARG=${shortcuts[$OPTARG]}"
    # echo "removed $1 from shortcuts"
    sed -i '/$OPTARG=${shortcuts[$OPTARG]}/d' ~/BashCDShortcuts/shortcuts.txt
}

changedir() {
    if [ "${shortcuts[$cdarg]}" ]
        then
            cd ~/${shortcuts[$cdarg]}
            pwd
        else
            echo "Shortcut not found"
    fi
}