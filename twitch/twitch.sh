#!/bin/bash

vid=$1

json=$(wget -q -O - --header "client-id: jzkbprff40iqj646a697cyrvl0zt2m6" https://api.twitch.tv/kraken/videos/v$vid)

json=${json#*title\":\"}; title=${json%%\"*}
json=${json#*length\":}; length=${json%%,*}
json=${json#*s3_vods/}; hash=${json%%/*}

length=$((length + 9 ))
length=$((length / 10 ))

mkdir $vid
title=$(echo "$title" | sed "s/\//\./g")
echo "download $title"
i=0
while [ ! $i = $length ]; do
  id=$((i+100000)); id=${id#1}
  echo -ne "download $((i+1))/$length ...\r"
  wget -c -q -O "$vid/$id.ts" "https://vod108-ttvnw.akamaized.net/$hash/chunked/$i.ts"

  i=$((i + 1))
done

cat $vid/*.ts > $vid/merge.tmp
ffmpeg -i $vid/merge.tmp -codec copy "$vid.$title.mp4"
if [ $? = 0 ]; then
  rm -rf $vid
fi
echo "done"
