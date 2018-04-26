#!/bin/bash

url=$1
id=${url##*/}

html=$(wget -U Mozilla --load-cookies=cookie --save-cookies=cookie --keep-session-cookies -q -O - "$url")

title=${html#*title>}; title=${title%%<*};
title=$(echo "$title" | sed 's/｜.*//')

m3u8=${html#*m3u8\":\"}; m3u8=${m3u8%%\"*}
m3u8=$(echo "$m3u8" | sed 's/\\//g')

m3u8=$(wget -q -O - -U Mozilla --load-cookies=cookie "$m3u8" | tr -d '\r')

echo $title
name="$title.$id.mp4"

i=0
echo "$m3u8" | grep ts | while read u; do
  j=$((i+10000)); j=${j#1}
  i=$((i+1))

  echo -ne "\r$j"

  wget -q -O "$id-$j.ts" -U Mozilla --load-cookies=cookie "https://svt.jav101.com/$id/$u"
done

cat $id*.ts > $id.tmp
ffmpeg -y -i $id.tmp -c copy "$name"

#ffmpeg -y -i "$m3u8" -headers "User-Agent: Mozilla" -headers "$(cat ffmpeg.cookie)\r\n" "$name"
