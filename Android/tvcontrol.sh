#!/usr/local/bin/bash

# Usage: tvcontrol [<device serial>]
# keyCodeMap=(["h"]="DPAD_LEFT" ["l"]="DPAD_RIGHT" ["k"]="DPAD_UP" ["j"]="DPAD_DOWN" ["e"]="DPAD_CENTER" ["b"]="BACK" ["g"]="HOME" ["s"]="SETTINGS" ["m"]="MENU")
# key "w" - long press of 'DPAD_CENTER'

# keyCodeMap=(["h"]="21" ["l"]="22" ["k"]="19" ["j"]="20" ["e"]="23" ["b"]="4" [" "]="3" ["g"]="3" ["s"]="176")
declare -A keyCodeMap=(["h"]="DPAD_LEFT" ["l"]="DPAD_RIGHT" ["k"]="DPAD_UP" ["j"]="DPAD_DOWN" ["e"]="DPAD_CENTER" ["b"]="BACK" ["g"]="HOME" ["s"]="SETTINGS" ["m"]="MENU")

if [ $# -lt 1 ]; then
    deviceSerial=none
else
    deviceSerial=$1
fi

key=""
numPrefix=""
# state can be: idle, number
state="idle"

function sendLongPressKeyEvent() {
  local keyCode=$1
  adb shell sendevent /dev/input/event0 1 $keyCode 1
  adb shell sendevent /dev/input/event0 0 0 0
  sleep 1
  adb shell sendevent /dev/input/event0 1 $keyCode 0
  adb shell sendevent /dev/input/event0 0 0 0
}

function handleEscKey {

    # Get the rest of the escape sequence (3 characters total)
    while IFS= read -r -n 2 -s rest
    do
        key+="$rest"
        break
    done
}

function handleNumKey {
    if [ $state == "idle" ]; then
        state="number"
        numPrefix=$key
    elif [ $state == "number" ]; then
        numPrefix=$numPrefix$key
    fi
}

while [ "$key" != "q" ]
do
    # Read one character at a time
    read -r -n 1 -s key
    if [ "$key" == $'\x1b' ] # \x1b is the start of an escape sequence
    then
        handleEscKey
        continue
    fi

    # long press of "DPAD_CENTER" key
    if [ "$key" == "w" ]; then
        sendLongPressKeyEvent 28
        continue
    fi

    if [[ $key = [0-9] ]]; then
        #echo "Press number key"
        keyCode="KEYCODE_$key"
    else
        keyCode=${keyCodeMap["$key"]}
    fi
    if [ "$keyCode" != "" ]; then
#        echo keyCode=$keyCode
        if [ $deviceSerial == none ]; then
            adb shell input keyevent $keyCode
        else
            adb -s $deviceSerial shell input keyevent $keyCode
        fi
    fi
done

