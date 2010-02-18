#!/bin/sh
#
# Continuous Build for Star Wars Uncut
# Runs all other pieces of the build
# in effect... this script remakes Star Wars!!11
#
# Jamie Wilkinson <http://jamiedubs.com> @jamiew github:jamiew
#

# tuned for my server
cd /home/jamie/vimeo-ripper
#RUBY="/usr/bin/env ruby"
RUBY="/opt/ruby-enterprise/bin/ruby"

# update
echo "Contacting Star Wars Uncut HQ ..."
$RUBY swu-compiler.rb

echo "Fetching latest videos ..."
$RUBY swu-ripper.rb

# echo "Rolling up dump of individual video files ..."
# rm -f output/00_daily_dump.tgz
# tar czvf output/00_daily_dump.tgz output/*

# transcode to intermediate format - temporarily disabled
###/bin/sh swu-transcode.sh

# generate a stitched video - temporarily disabled
###/bin/sh swu-merge.sh

echo "SWU build complete! May the Force be with you."
exit
