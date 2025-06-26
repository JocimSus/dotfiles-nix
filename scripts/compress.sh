#!/usr/bin/env bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Syntax:"
  echo "./compress.sh <input-name> <output-name>"
  exit 1
fi

ffmpeg \
  -hwaccel cuda -hwaccel_output_format cuda \
  -i "$1" \
  -c:v hevc_nvenc \
  -preset fast \
  -rc:v vbr_hq \
  -crf 28 \
  "$2"
