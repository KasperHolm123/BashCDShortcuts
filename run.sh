#!/bin/bash

declare -A shortcuts


function fill_array() {
    declare -gA shortcuts
    while read line; do 
        key=$(echo $line | cut -d "|" -f1)
        data=$(echo $line | cut -d "|" -f2)
        shortcuts[$key]="$data"
    done < ~/BashCDShortcuts/shortcuts.txt
}

# fill array with all shortcuts in container
if [ -e ~/BachCDShortcuts/ ]
then
    fill_array
fi

function cdproj () {
    # no options
    if [ $# == 0 ]
    then
        echo "error: no options given"
        return
    fi

    # conatiner not found
    if [ ! -e ~/BashCDShortcuts/shortcuts.txt ] && [ $# == 0 ]
    then
        echo "Container directory missing. Use 'cdproj -m' to create it"
        return
    fi

    # container not found
    if [ ! -e ~/BashCDShortcuts/shortcuts.txt ] && [ $1 != "-m" ] && [ $1 != "--makedirectory" ]
    then
        echo "Container directory missing. Use 'cdproj -m' to create it"
        
        return
    fi

    # help
    if [ $1 == "-h" ] || [ $1 == "--help" ]
    then
        echo "usage"
        echo "  -l or --list              Shows all available shortcuts"
        echo "  -m or --makedirectory     Creates shortcut container directory"
        echo "  -d or --delete            Deletes shortcut container directory"
        echo "  -c or --changedirectory   Changes directory to the value of a shortcut"
        echo "  -n or --newshortcut       Creates a new shortcut"
    fi

    # list all shortcuts
    if [ $1 == "-l" ] || [ $1 == "--list" ]
    then
        echo "All shortcuts:"
        for x in "${!shortcuts[@]}"
        do
            echo "$x|${shortcuts[$x]}"
        done
    fi

    # create container dir
    if [ $1 == "-m" ] || [ $1 == "--makedirectory" ]
    then
        mkdir ~/BashCDShortcuts
        echo "Created directory for container at ~/BachCDShortcuts"
        touch ~/BashCDShortcuts/shortcuts.txt
        echo "Created container for shortcuts at ~/BashCDShortcuts/shortcuts.txt"
        fill_array
        return
    fi

    # delete container dir
    if [ $1 == "-d" ] || [ $1 == "--delete" ] && [ -e ~/BashCDShortcuts ]
    then
        rm -rf ~/BashCDShortcuts
        echo "Delete ~/BashCDShortcuts recursively"
    fi

    # change directory to a shortcut
    if [ $1 == "-c" ] || [ $1 == "--changedirectory" ]
    then
        if [ ! -z "${shortcuts["$2"]}" ]
        then
            cd ~/${shortcuts[$2]}
            pwd
        else
            echo "Shortcut not found"
        fi
    fi

    # create new shortcut
    if [ $1 == "-n" ] || [ $1 == "--newshortcut" ]
    then
        echo "$2" >> ~/BashCDShortcuts/shortcuts.txt
        fill_array
    fi
}