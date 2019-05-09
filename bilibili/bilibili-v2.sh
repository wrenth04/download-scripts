#!/bin/bash

AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36"

url="$1"

html=$(cat data.html)

series_title=${html#*series_title\":\"}; series_title=${series_title%%\"*}
x=${html#*epList}
x2=${x#*\"aid\":}

while [ "$x" != "$x2" ]; do
  avid=${x2%%,*}
  cid=${x2#*cid\":}, cid=${cid%%,*}
  ep_id=${x2#*ep_id\":}, ep_id=${ep_id%%,*}
  title=${x2#*index_title\":\"}, title=${title%%\"*}
  ep=${x2#*\"index\":\"}, ep=${ep%%\"*}
  ep=$((ep+100)); ep=${ep#1}
  api="https://api.bilibili.com/pgc/player/web/playurl?avid=$avid&cid=$cid&qn=0&type=&otype=json&ep_id=$ep_id&fnver=0&fnval=16"
  json=$(wget -O - -q -U "$AGENT" "https://api.bilibili.com/pgc/player/web/playurl?avid=$avid&cid=$cid&qn=0&type=&otype=json&ep_id=$ep_id&fnver=0&fnval=16")
  echo "$title"
  echo "$json"

  i=0
  y=${json}
  y2=${y#*\"url\":\"}
  while [ "$y" != "$y2" ]; do
    video=${y2%%\"*}
    id=$((i+100)); id=${id#1}
    echo "$id $video"
    file="tmp-$id.tmp"
    if [ $i = 0 ]; then
      echo "file '$file'" > input.txt
    else
      echo "file '$file'" >> input.txt
    fi
    wget -O "$file" -U "$AGENT" "$video"
    i=$((i+1))
    y=${y2}
    y2=${y#*\"url\":\"}
  done
  echo $files
  ffmpeg -y -f concat -i input.txt -c copy "$series_title-$ep-$title.mp4"
  
  x=${x2}
  x2=${x#*\"aid\":}
done
