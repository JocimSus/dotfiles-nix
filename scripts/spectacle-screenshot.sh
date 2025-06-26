#!/usr/bin/env bash

out=/tmp/screenshot.png

spectacle -r -b -n -o "$out"
ret=$?

if [[ $ret -ne 0 ]] || [[ ! -s "$out" ]]; then
  rm -f "$out"
  exit 0
fi

curl \
  -H "authorization: MTc1MDQyNzQ1ODE3Mg==.Nzk4NmZjODY5ZGU5OTExMDhiN2MwN2U4OWExZGMyYzQuMDQwNzhmMWVlMDg2NzM1MDA3M2U5ZWIyMTQzZWE1OTU5ZmM4NTI1NmFiYjI5OTMwZDc3ZmI4YTBlNDgxNGQyNTFjY2FlNDQ5YWRhMjEwMDc4ZTk0ZjkyNDBlM2I5NGQyYTYyNjViZGYwYThkOWZkMzRhNDBlODA0MGM2OGFkMDBjMzgwZjcxMWZjODQ4MDU1NDk3MDg2MTA3MTM3MjE5Zg==" \
  https://zip.224668.xyz/api/upload \
  -F file=@"$out" \
  -H 'content-type: multipart/form-data' \
| jq -r .files[0].url \
| tr -d '\n' \
| wl-copy

rm -f "$out"
