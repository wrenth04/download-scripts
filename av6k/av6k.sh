#!/bin/bash

#http://av6k.com/jxny/1.html

from=$1
to=$2
tag=$3

from=${from:=1}
to=${to:=999}
tag=${tag:=jxny}

page=$from

parsePage() {
  page=$1
  x=$(wget -O - -U Mozilla -q "http://av6k.com/$tag/$page.html")
  x2=${x#*listAC\"}
  
  while [ "$x" != "$x2" ]; do
    title=${x2#*title=\"}; title=${title%%\"*}
    url=${x2#*href=\"}; url="http://av6k.com${url%%\"*}"
    img=${x2#*src=\"}; img=${img%%\"*}
    id=${url##*/}; id=${id%%.*}
    echo $id $url $img $title
 
    x=$x2
    x2=${x#*listAC\"}
  done
}

while [ $page -le $to ]; do
  #parsePage $page 
  parsePage $page | ./download.sh
  page=$((page+1))
done
