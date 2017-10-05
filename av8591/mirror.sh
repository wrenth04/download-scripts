#!/bin/bash

TOKEN="Authorization: Bearer token"
PARENT="folder id"

get() {
  wget -O - -U Mozilla -q --load-cookies cookies.txt --save-cookies cookies.txt --keep-session-cookies $@
}

copy() {
  id=$1; name="$2"
  curl -X POST -H "$TOKEN" -H "Content-Type: application/json" "https://www.googleapis.com/drive/v3/files/$id/copy" -d "{\"parents\":[\"$PARENT\"],\"name\":\"$name\"}"
}

checkFile() {
  name="$1"
  if [$(wget -q -O - --header "$TOKEN" "https://www.googleapis.com/drive/v3/files?q='$PARENT' in parents and trashed = false and name = '$name'" | wc -l) = 5 ]; then
    echo 0
  else
    echo 1
  fi
}

parseVideo() {
  url=$1

  html=$(get "$url")
  
  checkAuth=$(echo "$html" | grep guestAuth)
  if [ ! "x" = "x$checkAuth" ]; then
    echo "auth..."
    authUri=${checkAuth#*href=\"}; authUri=${authUri%%\"*}
    auth=$(get "$authUri")
    html=$(get "$url")
  fi
  
  name=$(echo "$html" | grep "og:title"); name=${name#*content=\'}; name="${name%%\'*}.mp4"
  id=$(echo "$html" | grep drive); id=${id%/preview*}; id=${id#*/d/}
  
  echo "copy $id $name"
  copy $id "$name"
}

cat list.txt | while read url img name; do
  if [ $(checkFile "$name.mp4") = 1 ]; then
    continue
  fi
  wget -q -O - "$img" | gdrive upload - -p $PARENT "$name.jpg"
  parseVideo "$url"
done
