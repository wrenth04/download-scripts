#!/bin/bash


from=$1
to=$2

if [ "x" = "x$from" ]; then exit; fi
if [ "x" = "x$to" ]; then exit; fi

FID=""
PROJECT_ID=""
API="https://$PROJECT_ID.firebaseio.com/jodora"

id=$((from-1))
while [ $id -le $to ]; do
  id=$((id+1))
  json=$(wget -q -O - $API/$id.json) 
  if [ "$json" = "null" ]; then continue; fi
  title="$(echo "$json" | jq -r '[.CHANNELNAME, .DISPLAYNAME, .COMMENT, .TAGS] | "\(.[0]).\(.[1]).\(.[2]).\(.[3])"' | sed 's/\//\./g').pandora.$id"
  img=$(echo "$json" | jq -r '.PICURL')
  video=${img#*/pic/}; video=${video%_L*}
  video="https://pandora-video.qcdn.network/limited.mvips/east/src_p/${video}_480p_750k.mp4"

  echo $title
  echo $img
  echo $video

  wget -q -O - "$video" | gdrive upload - -p $FID "$title.mp4"
  wget -q -O - "$img"   | gdrive upload - -p $FID "$title.jpg"
done
