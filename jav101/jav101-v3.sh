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
r=$RANDOM
tmp="$r.m3u8"
prefix=${m3u8%/*}; prefix=$(echo "$prefix" | sed 's/\//\\\//g')
wget -q -O - -U "$AGENT" --load-cookies=cookie "$m3u8" | sed "s/ts/$prefix\/ts/" | sed 's/\.ts.*/\.ts/'> $tmp
echo $title
name="$title.$id.mp4"
#ffmpeg -y -allowed_extensions ALL -protocol_whitelist "file,https,crypto,tcp,tls" -i "$tmp" -c copy "$name"
i=0
total=$(cat $tmp | wc -l)
echo ""
cat $tmp | grep ts | while read s; do
  i=$((i+1))
  id=$((i+10000)); id=${id#1}
  echo -e "\r $id / $total"
  wget -q -U "$AGENT" -O $r-$id.ts --load-cookies=cookie "$s"
done
cat $r-*.ts > $r.tmp
ffmpeg -i $r.tmp -c copy "$name"

rm $r.m3u8 $r-*.ts $r.tmp

