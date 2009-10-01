#!/bin/sh
# swu-transcode.sh
#
# transcodes all orogina files into a common (fairly low-res) format,
# currently using MPEG for intermediates to use MPEG2 concatenation, then re-encode
#

#DIRNAME=${0%/*}
#. $DIRNAME/binaries.sh
FFMPEG=/usr/local/bin/ffmpeg

mkdir -p intermediate
for i in originals/*; do  
  # ffmpeg -y -r 24 -sameq -s 640x480 -aspect 4:3 -acodec aac -ab 128k -i "$i" "intermediate/$(basename $i).mpg"
  OUTPUT="intermediate/$(basename $i).mpg"
  if [ ! -e $OUTPUT ]; then
    echo "Transcoding $i ..."

    $FFMPEG -i "$i" -sameq -ab 128k -s 640x480 -aspect 4:3 -r 24 "$OUTPUT"

  fi
done

echo "Done transcoding."
exit 0


#
# smaller MPEG:
# $FFMPEG -i $i -s 320x240 -aspect 4:3 -r 24 -b 500k "$OUTPUT"
#
# AVI:
# $FFMPEG -y -i "$i" -sameq -s 640x480 -aspect 4:3 -r 24 -acodec aac -ab 128k "$OUTPUT"
#
# MP4:
# $FFMPEG -i "$i" -f mp4 -vcodec libxvid -maxrate 1000 -qmin 3 -qmax 5 -bufsize 4096 -g 300 -acodec aac -s 640x480 -ab 128k -b 500k "$OUTPUT"
#
