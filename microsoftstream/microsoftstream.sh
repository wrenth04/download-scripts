#!/bin/bash

COOKIE="microsoftstream  cookie"

url="$1"
if [ "$url" = "${url#*http}" ]; then
  id="$url"
else
  id="${url##*\/}"
fi

echo $id

sessionInfo=$(wget -q -O - --header "cookie: $COOKIE" "https://web.microsoftstream.com/video/$id" | grep sessionInfo)
api_gateway_uri=${sessionInfo#*ApiGatewayUri\":\"}
api_gateway_uri=${api_gateway_uri%%\"*}
api_gateway_version=${sessionInfo#*ApiGatewayVersion\":\"}
api_gateway_version=${api_gateway_version%%\"*}
access_token=${sessionInfo#*AccessToken\":\"}
access_token=${access_token%%\"*}

json=$(wget -q -O - --header "authorization: Bearer $access_token" "${api_gateway_uri}videos/$id?\$expand=creator&api-version=$api_gateway_version")
video_url=$(echo "$json" | jq -r ".playbackUrls[].playbackUrl" | grep m3u8)
name=$(echo "$json" | jq -r ".name")

echo "$name"
echo "$video_url"

ffmpeg -headers "authorization: Bearer $access_token" -i "$video_url" -c copy "$name.mp4"
