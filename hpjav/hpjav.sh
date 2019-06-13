#!/bin/bash

FID=""

url="$1"
html=$(wget -U Mozilla -q -O - "$url")

title=${html#*h1>}; title=${title%%<*}
title=$(echo "$title" | sed 's/\//\./g')

x=${html#*hr-tags}; x=${x%%hr-Models*}
x2=${x#*title=\"}

tags=""
while [ "$x" != "$x2" ]; do
  tag=${x2%%\"*}
  tags="$tags.$tag"
  x=${x2}
  x2=${x#*title=\"}
done

x=${html};
x2=${x#*video-box-model-name\">}
models=""
while [ "$x" != "$x2" ]; do
  model=${x2%%<*}
  models="$models.$model"
  x=${x2}
  x2=${x#*video-box-model-name\">}
done
name="$title${tags:=}${models:=}.hpjav.mp4"
img=${html#*background: url(}; img=${img%%)*}

n=$(gdrive list -q "name='$name' and trashed=false" | wc -l)
if [ $n != 1 ]; then exit; fi
echo $name
echo $img

node launchChrome.js
links=$(node hpjav.js "$url")

echo "$links" | while read link; do
  html=$(wget -U Mozilla -q -O - "https://verystream.com/stream/$link")
  videolink=${html#*videolink\">}; videolink=${videolink%%<*}
  wget -U Mozilla -q -O - "https://verystream.com/gettoken/$videolink?download=true" | gdrive upload - -p $FID "$name"
done
wget -U Mozilla -q -O - "$img" | gdrive upload - -p $FID "${name%.*}.jpg"
