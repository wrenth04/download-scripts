#!/bin/bash

id=$1

data=$(wget -U Mozilla -q -O - "http://www.youtube.com/get_video_info?eurl=http%3A%2F%2Fkej.tw%2F&sts=17316&video_id=$id")

node ../decode.js "$data" | grep "H.264" | grep "AAC" | while read url title o; do
  wget -U Mozilla -O "$title.mp4" "$url"
  break
done
