#!/bin/bash

url="$1"
html=$(wget -O - "$url")
player=$(echo "$html" | grep Player)
player=${player#*src=\"}; player=${player%%\"*}
title=${html#*thread_subject\">}; title=${title%%<*}
title=$(echo "$title" | sed 's/[ \\\/][ \\\/]*/\./g')

echo "$player"
m3u8=$(wget -O - "$player" --referer "$url" | grep m3u8)
m3u8=${m3u8#*\'}; m3u8=${m3u8%%\'*}
name="$title.mp4"
echo $name
echo $m3u8
youtube-dl -o "$name" "$m3u8"

