#!/bin/bash

url=$1

html=$(wget -U Mozilla -q -O - "$url")

id=${url#*manhua/}; id=${id%/*}

x=${html#*chapter-list}
x2=${x#*\/$id\/}

while [ "$x" != "$x2" ]; do
  link=${x%%\"*}
  title=${x#*_zj\">}; title=${title%%<*}

  echo "/manhua/$id/$link $title"

  x=${x2}
  x2=${x#*\/$id\/}
done

