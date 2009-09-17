#!/bin/sh

mkdir -p intermediate
for i in originals/*; do  
  # FIXME: end up saving as .mp4.mpg
  # ffmpeg -y -r 24 -sameq -s 640x480 -aspect 4:3 -acodec aac -ab 128k -i "$i" "intermediate/$(basename $i).mpg"
  OUTPUT="intermediate/$(basename $i).mpg"
  if [ ! -e $OUTPUT ]; then
    echo "Transcoding $i ..."
    ffmpeg -i "$i" -vcodec mpeg1video -ab 128k -s 640x480 -aspect 4:3 -r 24 "$OUTPUT"
  fi
done

echo "Done transcoding."
exit 0
