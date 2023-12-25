#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <audio_folder>"
    exit 1
fi

audio_folder="$1"

total_duration_seconds=0

for file in "$audio_folder"/*.mp3; do
    if [ -f "$file" ]; then
        duration=$(ffmpeg -i "$file" 2>&1 | grep Duration | awk '{print $2}' | tr -d ,)
        duration_seconds=$(echo "$duration" | awk -F: '{print ($1 * 3600) + ($2 * 60) + int($3)}')
        total_duration_seconds=$((total_duration_seconds + duration_seconds))
    fi
done

total_duration_hours=$(echo "scale=5; $total_duration_seconds / 3600" | bc)

echo "Total duration of audio files in $audio_folder: $total_duration_hours hours"
