#!/bin/sh

FFMPEG=/usr/local/bin/ffmpeg

mkdir -p render
MERGED="render/merged.mpg"
if [ ! -e $MERGED ]; then 
  echo "Merging transcoded videos ..."
  cat intermediate/* > $MERGED
fi

OUTPUT="render/merged.mov"
if [ ! -e $OUTPUT ]; then
  echo "Re-encoding as $OUTPUT ..."

  # $FFMPEG -y -i "render/merged.mpg" "$OUTPUT"
  $FFMPEG -y -i "$MERGED" -vcodec libx264 -acodec libfaac -vpre fastfirstpass -b 400k -bt 1M -threads 0 "$OUTPUT"

fi

# mencoder intermediate/* -o render/output.avi -ovc x264 -x264encopts bitrate=3000 -oac mp3lame
#TODO: subtitles

echo "Done merging & re-encoding."
exit 0


# 
# eugenia's hi-res h264 render (from vimeo forums): 
# mencoder originals/004_6635199.mov -aspect 4:3 -of lavf -lavfopts format=psp -oac lavc -ovc lavc -lavcopts aglobal=1:vglobal=1:coder=0:vcodec=libx264:acodec=libfaac:vbitrate=1000:abitrate=128 -vf scale=640:480 -ofps 30000/1001 -o render/test-ps3.mp4
#
# Ogg Theora: 
# ffmpeg -i ../originals/004_6635199.mov -sameq test3-004.ogg
#
# DV (good for Final Cut editing):  
# ffmpeg -i ../originals/004_6635199.mov -target ntsc-dv -sameq test2-004.dv
# 
