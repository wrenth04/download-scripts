#!/bin/bash

HOST="http://www.930mh.com"
chapter_list=$1
if [ "x$chapter_list" = "x" ]; then chapter_list="chapter.txt"; fi

i=0
cat $chapter_list | while read url title; do
  echo $HOST$url $title
  i=$((i+1))
  chapter=$((i+1000)); chapter=${chapter#1}

  #http://mhimg.acg.gd:44236/images/comic/170/339401/15155065861X-_I8A4oERAxnfy.jpg
  html=$(wget -U Mozilla -q -O - "$HOST$url")
  chapter_imgs=${html#*chapterImages}; chapter_imgs=${chapter_imgs%%\]*}
  chapter_path=${html#*chapterPath}; chapter_path=${chapter_path#*\"}; chapter_path=${chapter_path%%\"*}
  echo $chapter_imgs

  j=0
  x="$chapter_imgs,"
  x2=${x#*,}
  while [ "$x" != "$x2" ]; do
    j=$((j+1))
    page=$((j+1000)); page=${page#*1}
    img=${x#*\"}; img=${img%%\"*}
    echo "$page http://mhimg.acg.gd:44236/$chapter_path$img"
    wget -c -q -O "${chapter}-${title}-${page}.jpg" -U Mozilla "http://mhimg.acg.gd:44236/$chapter_path$img" &
    x=$x2
    x2=${x#*,}
    sleep 1
  done

done
