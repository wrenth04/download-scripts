#!/bin/bash

cat type.txt | while read en ch; do
  url="http://boneash.oldgame.tw/Pc/pcgame-$en.html"
  if [ ! -e "$ch" ]; then mkdir $ch; fi
  
  html=$(wget -U Mozilla -q -O - "$url" | iconv -f big5 -t utf8)

  node parseList "$html" | while read url name; do
    name=$(echo "$name" | sed "s/\///g")
    if [ -e "$ch/$name" ]; then continue; fi
    echo "download $ch/$name"
    html=$(wget -U Mozilla -q -O - "http://boneash.oldgame.tw/Pc/$url" | iconv -f big5 -t utf8)
    fileid=${html#*google}; fileid=${fileid#*d/}; fileid=${fileid%%/*}
    gdrive download --stdout $fileid > "$ch/$name"
  done
done

