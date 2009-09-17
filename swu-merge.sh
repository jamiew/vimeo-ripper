#!/bin/sh

mkdir -p render

MERGED="render/merged.mpg"
if [ ! -e $MERGED ]; then 
  echo "Merging transcoded videos ..."
  cat intermediate/* > $MERGED
fi

OUTPUT="render/merged.mov"
if [ ! -e $OUTPUT ]; then
  echo "Re-encoding as $OUTPUT ..."
  ffmpeg -y -i "render/merged.mpg" "$OUTPUT"
fi

# mencoder intermediate/* -o render/output.avi -ovc x264 -x264encopts bitrate=3000 -oac mp3lame
#TODO: subtitles

echo "Done merging & re-encoding."
exit 0
