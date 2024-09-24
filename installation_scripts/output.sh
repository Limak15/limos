#! /usr/bin/env bash

#Formatting
BOLD="\033[1m"
ITALIC="\033[3m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
WHITE="\033[37m"
RESET="\033[0m"

#BOXES
VERT_LINE="\u2503"
HORI_LINE="\u2501"
TOP_LEFT_CORNER="\u250f"
TOP_RIGHT_CORNER="\u2513"
BOT_RIGHT_CORNER="\u251b"
BOT_LEFT_CORNER="\u2517"

TITLE="LimOS Installer"

function CURSOR_COL() {
    echo "\033[${1}G"
}


max_width=$(tput cols)
line_width=$((max_width-4))

function info() {
    len=${#1}
    lines=$((len / line_width))
    wordarray=($1)
    buffer=""

    if [ $((len % line_width)) -gt 0 ]; then
        ((lines+=1))
    fi

    for i in $(seq 1 $max_width); do
        if [ $i -eq 1 ]; then
            buffer+="$TOP_LEFT_CORNER"
            continue
        fi

        if [ $i -eq $max_width ]; then
            buffer+="$TOP_RIGHT_CORNER"
            continue
        fi

        buffer+="$HORI_LINE"
    done

    buffer+="$(CURSOR_COL 3) ${BOLD}Informations${RESET} $(CURSOR_COL $max_width)"

    curr_width=0
    buffer+="\n${VERT_LINE}$(CURSOR_COL 3)"
    for word in ${wordarray[@]}; do
        wordlen=${#word}

        if [ $((curr_width+wordlen)) -gt $line_width ]; then
            buffer+="$(CURSOR_COL $max_width)${VERT_LINE}\n${VERT_LINE}$(CURSOR_COL 3)"
            curr_width=0
        fi
        
        buffer+="$word "
        
        curr_width=$((curr_width+wordlen+1))
    done
    buffer+="$(CURSOR_COL $max_width)$VERT_LINE"

    for i in $(seq 1 $max_width); do
        if [ $i -eq 1 ]; then
            buffer+="$BOT_LEFT_CORNER"
            continue
        fi

        if [ $i -eq $max_width ]; then
            buffer+="$BOT_RIGHT_CORNER"
            continue
        fi

        buffer+="$HORI_LINE"
    done

    echo -e $buffer
}

function msg() {
    whiptail --title "$TITLE" --msgbox "$1" 16 60
}

function yn() {
    whiptail --title "$TITLE" --yesno "$1" 16 60
}

function error() {
    echo -e "${RED}${BOLD}ERROR:${RESET} $1"; exit 1
}
