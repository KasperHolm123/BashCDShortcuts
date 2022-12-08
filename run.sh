#!/bin/bash

declare -A shortcuts

shortcuts=( ["mood"]="github/fritids_projekter/" )

function testfunc () {
    if [ ! -z "${shortcuts["$1"]}" ]
    then
        cd ~/"${shortcuts[$1]}"
    fi
}


function cdproj2 () {
    if [ ! -e ~/BashCDShortcuts/shortcuts.txt ] && [ $# == 0 ]
    then
        echo "Container directory missing. Use 'cdproj -m' to create it"
        return
    fi

    if [ ! -e ~/BashCDShortcuts/shortcuts.txt ] && [ $1 != "-m" ] && [ $1 != "--makedirectory" ] || [ $# == 0 ]
    then
        echo "Container directory missing. Use 'cdproj -m' to create it"
        return
    fi

    if [ $1 == "-l" ] || [ $1 == "--list" ]
    then
        cat ~/BashCDShortcuts/shortcuts.txt
    fi

    if [ $1 == "-m" ] || [ $1 == "--makedirectory" ]
    then
        mkdir ~/BashCDShortcuts
        echo "Created directory for container at ~/BachCDShortcuts"
        touch ~/BashCDShortcuts/shortcuts.txt
        echo "Created container for shortcuts at ~/BashCDShortcuts/shortcuts.txt"
        return
    fi

    if [ $1 == "-c" ] || [ $1 == "--clear" ] && [ -e ~/BashCDShortcuts ]
    then
        rm -rf ~/BashCDShortcuts
        echo "Deleted ~/BashCDShortcuts recursively"
    fi
}