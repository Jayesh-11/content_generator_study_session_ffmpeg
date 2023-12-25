#!/bin/bash

mylist="mylist.txt"
randomlist="random.txt"

for f in ./happy/*.mp3; do
    echo "file '$f'" >> "$mylist"
done

shuf "$mylist" > "$randomlist"
# awk '{print "file " $0}' "$randomlist" > temp_list.txt

ffmpeg -f concat -safe 0 -i random.txt -c copy output_rand.mp3

# for f in ./happy/*.mp3; do echo "file '$f'" >> mylist.txt; done

# sort -Ru mylist.txt >> random.txt; done
