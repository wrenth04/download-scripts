#!/bin/bash

#https://www.ptt.cc/bbs/Beauty/index2198.html

parseImg() {
  while read num url title; do 
    #if [ ! $num = "爆" ]; then continue; fi
    html=$(wget -q -U Mozilla -O - "https://www.ptt.cc$url")
    hash=${url##*/}; hash=${hash%.*}
    echo "$num.$title.$hash"
    id1="x"; id2="x2"
    echo "$html" | grep imgur | while read line; do 
      img=${line#*imgur.}; img=${img%%\"*}; img=${img##*/}; img=${img%%\.*}
      name="$num.$title.$img.$hash.jpg"
      id2=$img
      if [ "$id1" = "$id2" ]; then continue; fi

      echo $img
      if [ -e "$num/$name" ]; then continue; fi
      wget -q -O "$num/$name" "http://i.imgur.com/$img.jpg"
      id1=$id2
    done
  done
}

parsePage() {
  p=$1
  html=$(wget -q -U Mozilla -O - "https://www.ptt.cc/bbs/Beauty/index$p.html")
  x=$html
  x2=${x#*r-ent}
  while [ ! "$x" = "$x2" ]; do
    x3=${x2%%r-ent*}
    x=$x2
    x2=${x#*r-ent}

    num=${x3#*nrec\">}; num=${num#*>} num=${num%%<*}
    n=$(echo "$num" | grep "\t\t" | wc -l)
    if [ $n = 1 ]; then num=0; fi
    link=${x3#*href=\"}; title=$link; link=${link%%\"*}
    if [ "x" = "x$link" ]; then continue; fi
    title=${title#*>}; title=${title%%<*}
   
    echo "$num $link $title" 
  done
}

from=$1; to=$2
page=$from
while [ ! $page = $to ]; do
  echo "$(date): page $page"
  parsePage $page | parseImg
  page=$((page + 1))
done
