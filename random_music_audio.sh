#!/bin/bash

mylist="./inputAndProcess/mylist.txt"
randomlist="./inputAndProcess/random.txt"

mylistCompiledAudio="./inputAndProcess/mylistCompiledAudio.txt"

for f in ./music/*.mp3; do
    echo "file '../$f'" >> "$mylist"
done

shuf "$mylist" > "$randomlist"
# awk '{print "file " $0}' "$randomlist" > temp_list.txt

ffmpeg -f concat -safe 0 -i ./inputAndProcess/random.txt -c copy ./inputAndProcess/output_rand.mp3

for i in {1..3}; do
    echo "file './output_rand.mp3'" >> "$mylistCompiledAudio"
done

ffmpeg -f concat -safe 0 -i ./inputAndProcess/mylistCompiledAudio.txt -c copy ./inputAndProcess/outputBigCompiled.mp3

# for f in ./happy/*.mp3; do echo "file '$f'" >> mylist.txt; done

# sort -Ru mylist.txt >> random.txt; done

duration_input_seconds=$(ffmpeg -i ./inputAndProcess/optimizedSize.mp4 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

duration_5min_seconds=$(ffmpeg -i ./inputAndProcess/5min.mp4 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

duration_20sec_seconds=$(ffmpeg -i ./inputAndProcess/20sec.mp4 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

ffmpeg -ss 0 -t $duration_input_seconds -i ./inputAndProcess/outputBigCompiled.mp3 "./inputAndProcess/input.mp3"
ffmpeg -ss 0 -t $duration_5min_seconds -i ./inputAndProcess/outputBigCompiled.mp3 "./inputAndProcess/5minAudio.mp3"
ffmpeg -ss 0 -t $duration_20sec_seconds -i ./inputAndProcess/outputBigCompiled.mp3 "./inputAndProcess/20secAudio.mp3"

