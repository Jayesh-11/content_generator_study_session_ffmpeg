#!/bin/bash

#Video process
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_video_file>"
    exit 1
fi

input_video="$1"
output_format="${input_video##*.}"

duration=$(ffmpeg -i "$input_video" 2>&1 | grep Duration | awk '{print $2}' | tr -d ,)
duration_minutes=$(echo "$duration" | awk -F: '{print ($1 * 60) + $2 + $3/60}')

ffmpeg -i "$input_video" -vcodec libx265 -crf 28 -preset ultrafast "./inputAndProcess/optimizedSize.$output_format"

timebase5min=$(echo "scale=20; 5 / $duration_minutes" | bc)

ffmpeg -itsscale $timebase5min -i "./inputAndProcess/optimizedSize.$output_format" -c copy "./inputAndProcess/5minUnoptimized.$output_format"
ffmpeg -i "./inputAndProcess/5minUnoptimized.$output_format" -filter:v fps=60 "./inputAndProcess/5min.$output_format"

timebase20sec=$(echo "scale=20; 1 / 15" | bc)

ffmpeg -itsscale $timebase20sec -i "./inputAndProcess/5min.$output_format" -c copy "./inputAndProcess/20secUnoptimized.$output_format"
ffmpeg -i "./inputAndProcess/20secUnoptimized.$output_format" -filter:v fps=60 "./inputAndProcess/20sec.$output_format"

ffmpeg -i "./inputAndProcess/20sec.$output_format" -vcodec libx265 -preset ultrafast -vf 'split[original][copy];[copy]scale=-1:ih*(16/9)*(16/9),crop=w=ih*9/16,gblur=sigma=20[blurred];[blurred][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' "./inputAndProcess/verticalBlur20sec.$output_format"

#Audio process
mylist="./inputAndProcess/mylist.txt"
randomlist="./inputAndProcess/random.txt"

mylistCompiledAudio="./inputAndProcess/mylistCompiledAudio.txt"

for f in ./music/*.mp3; do
    echo "file '../$f'" >> "$mylist"
done

shuf "$mylist" > "$randomlist"

ffmpeg -f concat -safe 0 -i ./inputAndProcess/random.txt -c copy ./inputAndProcess/output_rand.mp3

for i in {1..3}; do
    echo "file './output_rand.mp3'" >> "$mylistCompiledAudio"
done

ffmpeg -f concat -safe 0 -i ./inputAndProcess/mylistCompiledAudio.txt -c copy ./inputAndProcess/outputBigCompiled.mp3

duration_input_seconds=$(ffmpeg -i ./inputAndProcess/optimizedSize.$output_format 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

duration_5min_seconds=$(ffmpeg -i ./inputAndProcess/5min.$output_format 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

duration_20sec_seconds=$(ffmpeg -i ./inputAndProcess/20sec.$output_format 2>&1 | awk '/Duration/ {split($2, a, ":"); print a[1]*3600 + a[2]*60 + a[3]}')

ffmpeg -ss 0 -t $duration_input_seconds -i ./inputAndProcess/outputBigCompiled.mp3 "./inputAndProcess/input.mp3"
ffmpeg -ss 0 -t $duration_5min_seconds -i ./inputAndProcess/outputBigCompiled.mp3 "./inputAndProcess/5minAudio.mp3"
ffmpeg -ss 0 -t $duration_20sec_seconds -i ./inputAndProcess/outputBigCompiled.mp3 "./inputAndProcess/20secAudio.mp3"

