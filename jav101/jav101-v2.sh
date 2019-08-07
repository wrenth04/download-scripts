#!/bin/bash

AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"

url=$1
id=${url##*/}

html=$(wget -U "$AGENT" --load-cookies=cookie --save-cookies=cookie --keep-session-cookies -q -O - "$url")

title=${html#*title>}; title=${title%%<*};
title=$(echo "$title" | sed 's/ | .*//')

m3u8=$(echo "$html" | grep m3u8 | sed 's/\&amp;/\&/g')
m3u8=${m3u8#*videoSrc = \"}
m3u8="${m3u8%%\"*}"
echo $m3u8
tmp="$RANDOM.m3u8"
wget -q -O $tmp -U "$AGENT" --load-cookies=cookie "$m3u8"
echo $title
name="$title.$id.mp4"
ffmpeg -y -allowed_extensions ALL -protocol_whitelist "file,https,crypto,tcp,tls" -i "$tmp" -c copy "$name"
rm $tmp

