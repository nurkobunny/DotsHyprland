#!/bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g"
bar_length=${#bar}

for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

CAVA_MAIN_CONFIG="$HOME/.config/cava/config"
USER_COLOR=$(grep -i "^FOREGROUND =" "$CAVA_MAIN_CONFIG" | cut -d'=' -f2 | tr -d '[:space:]"' | sed "s/'//g")

if [[ "$USER_COLOR" != "#"* ]]; then
    USER_COLOR="#$USER_COLOR"
fi

config_file="/tmp/bar_cava_config_$RANDOM"

cat >"$config_file" <<EOF
[general]
framerate = 30
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7

[color]
gradient = 0
foreground = '$USER_COLOR'
EOF

cava -p "$config_file" | sed -u "$dict"
