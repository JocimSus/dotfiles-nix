#!/usr/bin/env bash

out=/tmp/screenshot.png

spectacle -r -b -n -o "$out"
ret=$?

if [[ $ret -ne 0 ]] || [[ ! -s "$out" ]]; then
  rm -f "$out"
  exit 0
fi

TOKEN=$(< /run/secrets/zipAuthToken)
ZIP_URL="https://zip.jocimsus.tech"

curl \
  -H "authorization: $TOKEN" \
  $ZIP_URL/api/upload \
  -F file=@"$out" \
  -H 'content-type: multipart/form-data' \
| tee ~/spec-ss_response \
| jq -r .files[0].url \
| tr -d '\n' \
| wl-copy

rm -f "$out"
