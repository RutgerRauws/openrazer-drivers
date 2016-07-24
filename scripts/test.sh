#!/bin/bash
# This script tests all available driver functionalities.

# Exit on error.
set -e

DRIVER_PATH="/sys/bus/hid/drivers/hid-razer"
DEVICE_PATH=""

COLOR='\033[0;31m'
NC='\033[0m' # No Color


if [[ ! -d "$DRIVER_PATH" ]]; then
    echo "driver is not loaded."
    exit 1
fi

# Find an attached device.
for d in "$DRIVER_PATH"/*
do
    if [[ $d == *:*:*\.* ]]; then
        DEVICE_PATH="$d"
        break
    fi
done

if [[ "$DEVICE_PATH" == "" ]]; then
    echo "no supported Razer device attached."
    exit 1
fi

echo "Using Razer device $DEVICE_PATH"


echo -n -e "${COLOR}get_firmware_version:${NC} "
cat "$DEVICE_PATH/get_firmware_version"

echo -n -e "${COLOR}get_serial:${NC} "
cat "$DEVICE_PATH/get_serial"

echo -n -e "${COLOR}device_type:${NC} "
cat "$DEVICE_PATH/device_type"

echo -e "${COLOR}get_info:${NC}"
cat "$DEVICE_PATH/get_info"

echo -n -e "${COLOR}brightness:${NC} "
cat "$DEVICE_PATH/brightness"

echo -e "${COLOR}set brightness to${NC} 50"
echo -n "50" > "$DEVICE_PATH/brightness"

echo -n -e "${COLOR}brightness:${NC} "
cat "$DEVICE_PATH/brightness"

sleep 2

echo -e "${COLOR}set brightness to${NC} 0"
echo -n "0" > "$DEVICE_PATH/brightness"

echo -n -e "${COLOR}brightness:${NC} "
cat "$DEVICE_PATH/brightness"

sleep 2

echo -e "${COLOR}set brightness to${NC} 255"
echo -n "255" > "$DEVICE_PATH/brightness"

echo -n -e "${COLOR}brightness:${NC} "
cat "$DEVICE_PATH/brightness"

sleep 2


# set_logo
if [[ -e "$DEVICE_PATH/set_logo" ]]; then
    echo -e "${COLOR}set logo${NC} off"
    echo -n "0" > "$DEVICE_PATH/set_logo"
    sleep 2
    echo -e "${COLOR}set logo${NC} on"
    echo -n "1" > "$DEVICE_PATH/set_logo"
    sleep 2
fi

# set_fn_toggle
if [[ -e "$DEVICE_PATH/set_fn_toggle" ]]; then
    echo -e "${COLOR}set fn mode${NC} 1"
    echo -n "1" > "$DEVICE_PATH/set_fn_toggle"
    sleep 2
    echo -e "${COLOR}set fn mode${NC} 0"
    echo -n "0" > "$DEVICE_PATH/set_fn_toggle"
    sleep 2
fi

# mode_none
if [[ -e "$DEVICE_PATH/mode_none" ]]; then
    echo -e "${COLOR}set mode: ${NC} none"
    echo -n "1" > "$DEVICE_PATH/mode_none"
    sleep 2
fi

# mode_static
if [[ -e "$DEVICE_PATH/mode_static" ]]; then
    echo -e "${COLOR}set mode: ${NC} static"
    echo -e -n "\xFF\x00\xFF" > "$DEVICE_PATH/mode_static"
    sleep 3
fi

# mode_custom
if [[ -e "$DEVICE_PATH/mode_custom" ]]; then
    echo -e "${COLOR}set mode: ${NC} custom"
    echo -n "1" > "$DEVICE_PATH/mode_custom"
    sleep 3
fi

# mode_wave
if [[ -e "$DEVICE_PATH/mode_wave" ]]; then
    echo -e "${COLOR}set mode: ${NC} wave"
    echo -n "1" > "$DEVICE_PATH/mode_wave"
    sleep 3
    echo -n "2" > "$DEVICE_PATH/mode_wave"
    sleep 3
fi

# mode_spectrum
if [[ -e "$DEVICE_PATH/mode_spectrum" ]]; then
    echo -e "${COLOR}set mode: ${NC} spectrum"
    echo -n "1" > "$DEVICE_PATH/mode_spectrum"
    sleep 5
fi

# mode_reactive
if [[ -e "$DEVICE_PATH/mode_reactive" ]]; then
    echo -e "${COLOR}set mode: ${NC} reactive"
    echo -e -n "\x02\xFF\x00\xFF" > "$DEVICE_PATH/mode_reactive"
    sleep 5
fi

# mode_starlight
if [[ -e "$DEVICE_PATH/mode_starlight" ]]; then
    echo -e "${COLOR}set mode: ${NC} starlight"
    echo -e "random colors"
    echo -e -n "\x03" > "$DEVICE_PATH/mode_starlight"
    sleep 5
    echo -e "one color"
    echo -e -n "\x03\xFF\x00\xFF" > "$DEVICE_PATH/mode_starlight"
    sleep 5
    echo -e "two colors"
    echo -e -n "\x03\xFF\x00\xFF\xFF\xFF\xFF" > "$DEVICE_PATH/mode_starlight"
    sleep 5
fi

# mode_breath
if [[ -e "$DEVICE_PATH/mode_breath" ]]; then
    echo -e "${COLOR}set mode: ${NC} breath"
    echo -e "random colors"
    echo -n "1" > "$DEVICE_PATH/mode_breath"
    sleep 7
    echo -e "one color"
    echo -e -n "\xFF\x00\xFF" > "$DEVICE_PATH/mode_breath"
    sleep 7
    echo -e "two colors"
    echo -e -n "\xFF\xFF\x00\xFF\xFF\xFF" > "$DEVICE_PATH/mode_breath"
    sleep 7
fi