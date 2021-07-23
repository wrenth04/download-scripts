#!/bin/bash

id=$1
end=$2
id=${id:-2}
if [ "x" = "x$end" ]; then end=$id; fi

AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.164 Safari/537.36"

while [ $id -le $end ]; do
  echo $id
  url="https://fanxxx.net/video/amateur-$id.html"
  html=$(wget -U "$AGENT" -q -O - "$url")
  if [ "x$html" = "x" ]; then
    url="https://fanxxx.net/video/amateu-$id.html"
    html=$(wget -U "$AGENT" -q -O - "$url")
  fi
  title=${html#*v:title\">}; title=${title%%<*}
  echo $title
  name="$title.fanxxx.amateur-$id.mp4"
  id=$((id+1))
  iframe=$(echo "$html" | grep iframe)
  url=${iframe#*src=\"}; url=${url%%\"*}
  echo $url
  html=$(wget -U "$AGENT" --referer "$url" -q -O - "$url" | grep innerHTML | tail -n 1)
  video=${html#*innerHTML = \"}; video=${video%\'*}
  video="https:${video%\"*}${video#*\'}&stream=1"
  echo $video
  wget -U "AGENT" -q --referer "$url" -O "$name" "$video"
done

