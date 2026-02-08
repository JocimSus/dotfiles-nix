#!/usr/bin/env bash

out=/tmp/screenshot.png

spectacle -r -b -n -o "$out"
ret=$?

if [[ $ret -ne 0 ]] || [[ ! -s "$out" ]]; then
  rm -f "$out"
  exit 0
fi

curl \
  -H "authorization: MTc2OTk0NTM0MDYxMw==.Zjc5ZTQ3ZmY2YjM5NmY3ZWRmZDYxYzg0LmU1Mzg2Nzk5MDYzMDJkNjA4MWI3OTBlZjkzZDVhOGE5MGE3MjNjYzQ1YTg3ZjEwNjM3NWIyN2U1ZTFhNmNkYzE1NWZmYzA3MjA1MjVkYjdmNGViNmFlZTA3ODJmZWQ5ZGU0NGE0ODFlNzVkNzExZDZhZTYyYjY4ODgwNzYxOWJlNTcuMWU2MjhkY2M2NGNjMGRiNWIyOGUwM2VjZjU2ZDFhYjc=" \
  https://zip.224668.xyz/api/upload \
  -F file=@"$out" \
  -H 'content-type: multipart/form-data' \
| jq -r .files[0].url \
| tr -d '\n' \
| wl-copy

rm -f "$out"
