#!/bin/sh
#
# Continuous Build for Star Wars Uncut
# in effect... this script remakes Star Wars!!11
# Jamie Wilkinson <http://jamiedubs.com> @jamiew github:jamiew
#

# tuned for my server
cd /home/jamie/vimeo-ripper
RUBY="/usr/bin/env ruby"

# update
echo "Contacting SWU HQ for list of uploads ..."
$RUBY swu-compiler.rb

echo "Fetching latest videos ..."
$RUBY vimeo-ripper.rb

# echo "Rolling up dump of individual video files ..."
# rm -f output/00_daily_dump.tgz
# tar czvf output/00_daily_dump.tgz output/*

# transcode to intermediate format
for i in output/*; do
  echo "Transcoding $i ..."
  ffmpeg -y -r 15 -sameq -s 640x480 -aspect 4:3 -i "$i" "intermediate/$(basename $i).mpg" #FIXME: ending up w/ .avi.mpg -- it's fine tho
done

# generate a stitched video
mkdir -f render
echo "Merging transcoded videos..."
cat intermediate/* > "render/merged.mpg"

OUTPUT="render/merged.mov"
echo "Re-encoding as $OUTPUT ..."
ffmpeg -i "render/merged.mpg" "$OUTPUT"

echo "Done! May the Force be with you."
exit