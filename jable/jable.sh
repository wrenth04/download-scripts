#!/bin/bash

url="$1"

AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"

html=$(wget -q -U "$AGENT" -O - "$url")
title=${html#*og:title\" content=\"}; title=${title%%\"*}
tag=${html#*keywords\" content=\"}; tag=${tag%%\"*}
img=${html#*og:image\" content=\"}; img=${img%%\"*}
m3u8=${html#*hlsUrl = \'}; m3u8=${m3u8%%\'*}
tag=$(echo "$tag" | sed 's/, /\./g')
name="jable.$title.$tag"

echo "$(date): $name, $m3u8"
youtube-dl "$m3u8" -o "$name.mp4"
wget -O "$name.jpg" "$img"

