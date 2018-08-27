#!/bin/bash

QUERY_HASH="42323d64886122307be10013ad2dcc44"
#QUERY_HASH="a5164aed103f24b03e7b7747a2d94e3c"
URL="https://www.instagram.com/graphql/query/"

username="$1"

if [ "x" = "x$username" ]; then
  username="modela_asia"
fi

rhx=
graphql() {
  json="$1"
  magic="$rhx:$json"
  md5=$(echo -n "$magic" | md5)
  url="$URL?query_hash=$QUERY_HASH&variables=$json"
  wget -q -O - -U Mozilla --header "x-instagram-gis: $md5" "$url"
}

get_user() {
  user_id=$1; after="$2"
  if [ "x" = "x$after" ]; then
    json=$(echo "{'id':'$user_id','first':50,'after':null}" | sed "s/'/\"/g")
  else
    json=$(echo "{'id':'$user_id','first':50,'after':'$after'}" | sed "s/'/\"/g")
  fi
  graphql "$json"
}

parse_username() {
  json="$1"
  x1=${json}
  x2=${x1#*text\":\"}
  while [ "$x1" != "$x2" ]; do
    username=${x2%%\"*}
    echo $username

    x1="$x2"
    x2=${x1#*text\":\"}
  done
}

page=$(wget -q -O - -U Mozilla "https://www.instagram.com/$username")
data=$(echo "$page" | grep _sharedData)
user_id=${data#*graphql}; user_id=${user_id#*id\":\"}; user_id=${user_id%%\"*}
rhx=${data#*rhx_gis\":\"}; rhx=${rhx%%\"*}

has_next_page="true"
end_cursor=
while [ "$has_next_page" = "true" ]; do
  json=$(get_user $user_id $end_cursor)
  has_next_page=${json#*has_next_page\":}; has_next_page=${has_next_page%%,*}
  end_cursor=${json#*end_cursor\":\"}; end_cursor=${end_cursor%%\"*}
  parse_username "$json"
done
