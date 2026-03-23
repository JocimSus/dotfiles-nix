#!/usr/bin/env bash

out=/tmp/video.mp4

spectacle -R r -b -n -o "$out"
ret=$?

if [[ $ret -ne 0 ]] || [[ ! -s "$out" ]]; then
  rm -f "$out"
  exit 0
fi

curl \
  -H "authorization: MTc3MzcxOTk5OTU4MA==.MTNkNjhjMzJiZmU2MGYwZWFmZTVmYWZkLmVlN2YxOTdmYmNiNTg1MjAyMzYzMGI5ZWQyYTY2NmM3NTUxNTFkZDQ3Y2VjMGMyYTIzMjQ1MzM2MDFhMWIwZjRmODdjMjA0NmY1Y2M2OGY4Y2JhMWNlMjk2NjI2NjY0NWVhMTAzNWQxZTFmMDQ0OTMxNWJlMDk3ZWYwOTAwYTMyZmIuMmQwZTM0ZDcwZTJmOWQzZmQ2NjM1NTNiNmIzZDkwNDY=" \
  https://zip.224668.xyz/api/upload \
  -F "file=@$out;type=video/mp4" \
  -H 'content-type: multipart/form-data' \
| jq -r .files[0].url \
| tr -d '\n' \
| wl-copy

rm -f "$out"
