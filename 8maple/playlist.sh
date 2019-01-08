#!/bin/bash

url="$1"

html=$(wget -U Mozilla -q -O - "$url")
all=${html#*entry-content}; all=${all%%function*}

x=${all}
x2=${x#*href=\"}

while [ "$x" != "$x2" ]; do
  url=${x2%%\"*}
  ./8maple.sh "$url"
  x=${x2}
  x2=${x#*href=\"}
done
