ffmpeg -i ./inputAndProcess/optimizedSize.mkv -i ./inputAndProcess/input.mp3 -c copy -map 0:v:0 -map 1:a:0 ./output/YTOriginal.mkv
ffmpeg -i ./inputAndProcess/5min.mkv -i ./inputAndProcess/5minAudio.mp3 -c copy -map 0:v:0 -map 1:a:0 ./output/YTLapse.mkv
ffmpeg -i ./inputAndProcess/verticalBlur20sec.mkv -i ./inputAndProcess/20secAudio.mp3 -c copy -map 0:v:0 -map 1:a:0 ./output/short.mkv
