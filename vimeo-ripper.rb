# ,.   ,.                 .  .        .-,--.                   
# `|  / . ,-,-. ,-. ,-.   |- |-. ,-.   `|__/ . ,-. ,-. ,-. ,-. 
#  | /  | | | | |-' | |   |  | | |-'   )| \  | | | | | |-' |   
#  `'   ' ' ' ' `-' `-'   `' ' ' `-'   `'  ` ' |-' |-' `-' '   
#                                              |   |           

# by jamiew for STAR WARS UNCUT archival, 2009-09-08
# <http://jamiedubs.com> :: <http://starwarsuncut.com>

require 'rubygems'
require 'mechanize'

# Bootstrap
config = YAML.load(File.open(File.dirname(__FILE__)+'/config.yml'))
raise "No config file" if config.nil? || config.empty?
raise "No videos list in config" if config['videos'].nil? || config['videos'].empty?

output_dir = "#{File.dirname(__FILE__)}/output"
FileUtils.mkdir(output_dir) rescue (puts "mkdir: #{$!}")

# Browser
agent = WWW::Mechanize.new
agent.user_agent_alias = "Mac Safari" #TEEHEE

# Authenticate
puts "Logging in..."
page = agent.get("http://vimeo.com/log_in")
form = page.forms[0]
form.fields[0].value = config['username']
form.fields[1].value = config['password']
page = agent.submit(form)

# Sanity check -- page should now say "Hello, Jamie Dubs"
title = (page/'title').content rescue "Error: #{$!}"
unless title =~ /Hello/
  STDERR.puts "Could not login; page title = #{title}"
  exit 1
end

# Iterate through our videos, downloading each
puts "Processing #{config['videos'].length} videos..."
config['videos'].each do |url|
  puts "URL: #{url.inspect}"
  page = agent.get(url)
  
  link = (page/'.file_extension a') # instead of .file_details, so we can grab 'MOV' text
  next if link.nil? || link.empty?
  
  href = link[0]['href']
  filename = "#{url.split('/')[-1]}.#{link[0].content.downcase}"
  puts "Saving #{href} => #{filename} ..."
  agent.get(href).save_as("#{output_dir}/#{filename}")
  
end

# My work here is done
exit 0

