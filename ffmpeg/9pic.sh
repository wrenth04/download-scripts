#!/bin/bash

name="$1"
size="$2" # 3x3

if [ "x" = "x$size" ]; then size="3x3"; fi

n1=${size%x*}; n2=${size#*x}
n=$((n1 * n2 + 1))

t=$(ffmpeg -i "$name" 2>&1| grep Duration )
hh=${t#*: }; mm=${hh#*:}; ss=${mm#*:}
hh=${hh%%:*}; mm=${mm%%:*}; ss=${ss%%.*}

frame=$((hh*3600*25 + mm*60*25 + ss*25))
delay=$((frame / n))
offset=$((delay/2))

ffmpeg -i "$name" -frames 1 -vf "select=not(mod($offset+n\,$delay)),scale=320:180,tile=$size" "${name%.*}.$size.png"
