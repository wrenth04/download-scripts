#!/bin/bash


userId="$1"
#userId="144150372447991506"

n=0
total=20

while [ $n -lt $total ]; do
  n=$((n+20))
  page=$((n/20))
  json=$(curl -q -H 'Host: api.imvideo.app' -H 'device-model: SM-N950F' -H 'os: android' -H 'os-version: 5.1.1' -H 'device-brand: samsung' -H 'user-id: ' -H 'user-token: ' -H 'device-id: abf02185-c632-3aa3-a119-a02f53741d53' -H 'round-id: 470af157-d555-41bd-a87f-c9e188a9f655' -H 'app-source: release' -H 'app-version: 1.2.9.3' -H 'location: TW' -H 'language: zh-TW' -H 'user-agent: okhttp/3.9.1' --compressed "https://api.imvideo.app/user/$userId/recordings?page_size=20&page=$page")
  total=${json#*total\":}; total=${total%%,*}

  echo "download $page"
  node decode.js "$json" | while read video name; do
    id=${video#*recording/}; id=${id%%/*}
    wget -c -O "$name.$id.mp4" "$video"
  done
done


