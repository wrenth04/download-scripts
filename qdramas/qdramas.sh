#!/bin/bash

url="$1"

parse_video() {
  url="$1"
  html=$(wget -U Mozilla -q -O - "$url")
  title=${html#*h1>}; title=${title%%<*}
  title=$(echo "$title" | sed 's/\//\./g')

  if [ -e "$title.mp4" ]; then
    return
  fi
  echo "download $title"
  
  y=${html}
  y2=${html#*getp(}
  while [ "$y" != "$y2" ]; do
    code=${y2%%)*}
    cp decode.js tmp.js
    echo "getp($code)" >> tmp.js
    res=$(node tmp.js)
    format=${res%;;*}
    video=${res#*;;}
    echo $res
    if [ $format = "m3u8" ]; then
      ffmpeg -y -nostdin -i "$video" -c copy "$title.tmp.mp4"
      mv "$title.tmp.mp4" "$title.mp4"
      break
    fi
    y=${y2}
    y2=${y#*getp(}
  done
}

parse_list() {
  url="$1"
  html=$(wget -U Mozilla -q -O - "$url")
  content=${html#*content }; content=${content%disqus_thread*}

  x=${content}
  x2=${x#*href=\"}
  while [ "$x" != "$x2" ]; do
    url="http://qdramas.info${x2%%\"*}"
    parse_video "$url"
    x=${x2}
    x2=${x#*href=\"}
  done
}

if [ "$url" != "${url%html}" ]; then
  echo "video"
  parse_video "$url"
else
  echo "list"
  parse_list "$url"
fi
