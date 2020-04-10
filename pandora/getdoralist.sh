#!/bin/bash


from=$1
to=$2

if [ "x" = "x$from" ]; then exit; fi
if [ "x" = "x$to" ]; then exit; fi

PROJECT_ID=""
API="https://$PROJECT_ID.firebaseio.com/jodora"

id=$((from-1))
img=
img2=
json=
while [ $id -le $to ]; do
  id=$((id+1))
  echo "$id"
  img2="$img"
  json=$(wget -q -O - --post-data "sessionId=guest_session&idList=$id&outputFormat=json" "http://api.iradiopop.com/IDDSDK_VIP/servlets/IRxSearchStationById" |jq '.IRxResponse.StationList[0].Station')
  img=$(echo "$json" | jq '.PICURL')

  if [ "x$img" = "x$img2" ]; then continue; fi

  curl -X PUT "$API/$id.json" -d "$json"
  sleep 1
done
