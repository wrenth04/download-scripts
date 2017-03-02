#!/bin/bash

BASE="http://g.sbkk88.com"
HOME="wangluo/shunvyoudu"
OUT="out.txt"

echo "" > $OUT

./getlinks "$BASE/$HOME" | grep html | while read link; do
  html=$(wget -q -O - "$BASE$link")
  title=${html#*title>}; title=${title%%<*}

  echo "" >> $OUT
  echo "" >> $OUT
  echo "$title" >> $OUT
  echo "" >> $OUT

  echo "$title" | iconv -f gbk -t utf8

  article=${html#*articleContent\">}; article=${article%%</div*}
  echo "$article" >> $OUT
done

cp $OUT tmp.txt

./2book $tmp.txt $OUT

