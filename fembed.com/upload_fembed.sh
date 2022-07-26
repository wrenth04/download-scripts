#!/bin/bash
n="$1"

# depend: base64, jq, split, curl, stat, grep

[[ -z $n ]] && exit

CLIENT_ID=
CLIENT_SECRET=

json=$(curl -s -X POST https://www.fembed.com/api/upload -d "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET" -H "Content-Type: application/x-www-form-urlencoded")

url=$(echo "$json" | jq -r ".data.url")
token=$(echo "$json" | jq -r ".data.token")

echo $url
echo $token

size=$(stat -c %s "$n")
meta="name $(echo -n "$n" | base64 -w 0), token $(echo -n "$token" | base64 -w 0)"
resume_url=$(curl -i -X POST $url -H "Upload-Length: $size" -H "Upload-Metadata: $meta" -H "Tus-Resumable: 1.0.0" | grep location)
resume_url=${resume_url#* }; resume_url=${resume_url%$'\r'}

rm upload.part*
split -b 5M -d "$n" "upload.part"

total=$((size / 5242880))
i=0

for npart in $(ls upload.part*); do
  echo "$npart $i / $total part"
  curl -i -X PATCH $resume_url -H "Tus-Resumable: 1.0.0" -H "Content-Type: application/offset+octet-stream" -H "Upload-Offset: $((5242880*$i))" --upload-file "$npart"
  i=$((i+1))
done

rm upload.part*
