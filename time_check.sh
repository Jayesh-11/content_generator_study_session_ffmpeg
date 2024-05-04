#!/bin/bash
duration_5min_seconds=$(ffmpeg -i ./inputAndProcess/5min.mp4 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

duration_20sec_seconds=$(ffmpeg -i ./inputAndProcess/20sec.mp4 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

duration_input_seconds=$(ffmpeg -i ./inputAndProcess/optimizedSize.mp4 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

echo $duration_input_seconds
echo $duration_5min_seconds
echo $duration_20sec_seconds