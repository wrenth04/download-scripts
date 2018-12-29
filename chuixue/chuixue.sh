#!/bin/bash

url="$1"

html=$(wget -U Mozilla -q -O - "$url" | iconv -f GBK -t UTF8)
bookname=${html#*vt:\'}; bookname=${bookname%%\'*}
echo $bookname

function page() {
while read link title; do
  mkdir -p "$bookname/$title"
  html=$(wget -U Mozilla -q -O - "http://www.chuixue.net$link")
  packed=${html#*packed=\"}; packed=${packed%%\"*}
  all=$(node decode.js "$packed")

  i=1
  y=${all}
  y2=${y#*=\"}
  echo "$title"
  while [ "$y" != "$y2" ]; do
    id=$((i+1000)); id=${id#*1}
    echo -e "\r$id"
    img=${y2%%\"*}
    wget -U Mozilla -q -O "$bookname/$title/$id.jpg" "http://img.huanleyunpai.com/$img"
    y=${y2}
    y2=${y#*=\"}
    i=$((i+1))
  done
done
}

x=${html#*color:green;}; x=${x%%script*}
x2=${x#*href=\"}
while [ "$x" != "$x2" ]; do
  link=${x2%%\"*}
  title=${x2#*title=\"}; title=${title%%\"*}

  echo "$link $title"
  
  x=${x2}; 
  x2=${x#*href=\"}
done | page

