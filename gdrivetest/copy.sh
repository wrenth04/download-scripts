#!/bin/bash

### reference
# https://www.npmjs.com/package/googleapis
# https://developers.google.com/drive/v3/reference/files/copy
# https://developers.google.com/drive/v3/reference/files/update

# copy.sh fileId folderId
fileId=$1
folderId=$2

TOKEN="token"
AUTH="Authorization: Bearer $token"

curl -X POST -H "$AUTH" -H "Content-Type: application/json" "https://www.googleapis.com/drive/v3/files/$fileId/copy" -d "{\"parents\":[\"$folderId\"]}"
