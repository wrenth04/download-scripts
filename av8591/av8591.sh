#!/bin/bash

url=$1

get() {
  wget -O - -U Mozilla -q --load-cookies cookies.txt --save-cookies cookies.txt --keep-session-cookies $@
}

html=$(get "$url")

checkAuth=$(echo "$html" | grep guestAuth)
if [ ! "x" = "x$checkAuth" ]; then
  echo "auth..."
  authUri=${checkAuth#*href=\"}; authUri=${authUri%%\"*}
  auth=$(get "$authUri")
  html=$(get "$url")
fi

id=$(echo "$html" | grep drive); id=${id%/preview*}; id=${id#*/d/}

gdrive download $id
