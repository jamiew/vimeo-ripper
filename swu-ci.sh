#!/bin/sh
cd /home/jamie/vimeo-ripper

# update
/opt/ruby-enterprise/bin/ruby swu-compiler.rb
/opt/ruby-enterprise/bin/ruby vimeo-ripper.rb

# roll up
cd output
rm -f /00_daily_dump.tgz
tar czvf 00_daily_dump.tgz *

# TODO: also generate a stitched video :)
