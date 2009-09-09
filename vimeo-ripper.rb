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
videos = YAML.load(File.open(File.dirname(__FILE__)+'/swu.yml'))
puts "Processing #{videos.length} videos..."
videos.each do |video|
  puts video.inspect
  title, url = video[:title], video[:url]
  puts "URL: #{url.inspect}  title: #{title}"
  page = agent.get(url)
  
  # Skip non-SWU...
  next unless title =~ /Star Wars Uncut - Scene/
  
  number = /Star Wars Uncut - Scene (\d+)/.match(title)[1].strip.chomp
  puts "Scene number = #{number}"
  
  link = (page/'.file_extension a') # instead of .file_details, so we can grab 'MOV' text
  next if link.nil? || link.empty?
  
  href = link[0]['href']
  filename = "#{number}.#{link[0].content.downcase}"
  puts "Saving #{href} => #{filename} ..."
  if File.exists?("#{output_dir}/#{filename}")
    puts "File exists, skipping..."
  else
    begin
      agent.get(href).save_as("#{output_dir}/#{filename}")
    rescue
      puts "Error: #{$!}"
    end
  end
  
end

# My work here is done
exit 0

