#!/bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

bar_length=${#bar}

for ((i = 0; i < bar_length; i++)); do
	dict+=";s/$i/${bar:$i:1}/g"
done

config_file="/tmp/bar_cava_config_$RANDOM"
cat >"$config_file" <<EOF
[general]
bars = 15

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
foreground = '#eab5dc'
EOF

cava -p "$config_file" | sed -u "$dict"
