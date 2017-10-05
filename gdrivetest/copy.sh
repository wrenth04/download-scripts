#!/bin/bash

# copy.sh fileId folderId
fileId=$1
folderId=$2

TOKEN="Bearer token"
ROOT_ID="root id"

exit
json=$(curl -X POST -H "Authorization: $TOKEN" -H "Content-Type: application/json" "https://www.googleapis.com/drive/v3/files/$fileId/copy" -d '{}')

id=${json#*id\": \"}; id=${id%%\"*}

curl -X PATCH -H "Authorization: $TOKEN" -H "Content-Type: application/json" "https://www.googleapis.com/drive/v3/files/$id?addParents=$folderId&removeParents=$ROOT_ID"
