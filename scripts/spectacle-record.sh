#!/usr/bin/env bash

out=/tmp/video.mp4
log_file=/tmp/spectacle-record.log

spectacle -R r -b -n -o "$out"
ret=$?

if [[ $ret -ne 0 ]] || [[ ! -s "$out" ]]; then
  rm -f "$out"
  exit 0
fi

TOKEN=$(< /run/secrets/zipAuthToken)
ZIP_URL="https://zip.jocimsus.tech"

RESPONSE=$(curl -s \
  -H "authorization: $TOKEN" \
  -F "file=@${out};type=$(file --mime-type -b "$out")" \
  -H "content-type: multipart/form-data" \
  "$ZIP_URL/api/upload")

echo "$RESPONSE" > $log_file

URL=$(echo "$RESPONSE" | jq -r .files[0].url 2>/dev/null)

if [[ "$URL" == "null" ]] || [[ -z "$URL" ]]; then
  echo "Upload failed Check $log_file" >&2
else
  echo -n "$URL" | wl-copy
fi
