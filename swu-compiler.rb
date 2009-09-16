#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'

agent = WWW::Mechanize.new
agent.user_agent = "Star Wars Uncut Assemblotron <http://jamiedubs.com>"

# Fetch Casey's dump
url = "http://starwarsuncut.com/scene/export/jamiedubs"
puts "Fetching #{url.inspect} ..."
page = agent.get(url)

# Process
output = []
text = page.body
puts text.inspect
rows = text.split("\n")
rows.each { |row|
  fields = row.split(',')
  output << { :vimeo_id => fields[0], :scene_id => fields[1] }
}
STDERR.puts "Found #{output.length} fields"

# Save
filename = "videos.yml"
File.open(filename, 'w') { |out| YAML.dump(output, out) }

exit 0