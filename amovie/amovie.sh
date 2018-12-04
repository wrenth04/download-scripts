#!/bin/bash

tag=$1

if [ "x$tag" = "x" ]; then tag="259LUXU"; fi

for page in {1..19}; do
  echo "page $page"
  html=$(wget -O - -q -U Mozilla "http://tag.av.movie/$tag/$page")
  
  x=${html}
  x2=${x#*video-item\"}
  
  while [ "$x" != "$x2" ]; do
    link=${x2#*href = \"}; link="http:${link%%\"*}"
    img=${x2#*src=\"}; img=${img%%\"*}
    title=${x2#*span>}; title=${title%%<*}
    id=${link##*/}
  
    echo "$link $img $id $title"
  
    x=${x2}
    x2=${x#*video-item\"}
  done | while read link img id title; do
    html=$(wget -O - -q -U Mozilla "$link")
    videoId=$(echo "$html" | grep videoId)
    videoId=${videoId#*videoId = \"}; videoId=${videoId%%\"*}
    title=${html#*title>}; title=${title%%<*}; title=${title% |*}
    json=$(wget -O - -q -U Mozilla "http://api.av.movie/video/players" --post-data "videoId=$videoId&source=16")
    #https:\/\/openload.co\/embed\/ZxCuh8hZE_Q\/","la
    video=${json#*openload}; video=${video#*d\\\/}; video=${video%%\\*}
    echo "$videoId $title $video $json"
  done
done
