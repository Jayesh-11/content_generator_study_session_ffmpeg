#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_video_file>"
    exit 1
fi

input_video="$1"
output_format="${input_video##*.}"

duration=$(ffmpeg -i "$input_video" 2>&1 | grep Duration | awk '{print $2}' | tr -d ,)
duration_minutes=$(echo "$duration" | awk -F: '{print ($1 * 60) + $2 + $3/60}')

ffmpeg -i "$input_video" -vcodec libx265 -crf 28 -preset ultrafast "optimizedSize.$output_format"

timebase5min=$(echo "scale=20; 5 / $duration_minutes" | bc)

ffmpeg -itsscale $timebase5min -i "optimizedSize.$output_format" -c copy "5minUnoptimized.$output_format"
ffmpeg -i "5minUnoptimized.$output_format" -filter:v fps=60 "5min.$output_format"

timebase20sec=$(echo "scale=20; 1 / 15" | bc)

ffmpeg -itsscale $timebase20sec -i "5min.$output_format" -c copy "20secUnoptimized.$output_format"
ffmpeg -i "20secUnoptimized.$output_format" -filter:v fps=60 "20sec.$output_format"

ffmpeg -i "20sec.$output_format" -vcodec libx265 -preset ultrafast -vf 'split[original][copy];[copy]scale=-1:ih*(16/9)*(16/9),crop=w=ih*9/16,gblur=sigma=20[blurred];[blurred][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' "verticalBlur20sec.$output_format"

# to run -> bash process_video.sh input.whateverFormat