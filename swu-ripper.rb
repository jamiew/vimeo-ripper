

# ,.   ,.                 .  .        .-,--.                   
# `|  / . ,-,-. ,-. ,-.   |- |-. ,-.   `|__/ . ,-. ,-. ,-. ,-. 
#  | /  | | | | |-' | |   |  | | |-'   )| \  | | | | | |-' |   
#  `'   ' ' ' ' `-' `-'   `' ' ' `-'   `'  ` ' |-' |-' `-' '   
#                                              |   |           

# see README for usage & dependencies
# written by jamiew for STAR WARS UNCUT archival, 2009-09-08
# <http://jamiedubs.com> :: <http://starwarsuncut.com>

require 'rubygems'
require 'mechanize'

# Bootstrap
config = YAML.load(File.open(File.dirname(__FILE__)+'/config.yml'))
raise "No config file" if config.nil? || config.empty?

output_dir = "#{File.dirname(__FILE__)}/output"
FileUtils.mkdir(output_dir) rescue (puts "mkdir: #{$!}")

# Browser
agent = WWW::Mechanize.new
agent.user_agent = "Star Wars Uncut Assemblotron <http://jamiedubs.com>"

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

# Load the files from a a YAML file generated by swu-compiler.rb
videos = YAML.load(File.open(File.dirname(__FILE__)+'/videos.yml'))

# Iterate through our videos, downloading each if it's new
puts "Processing #{videos.length} videos..."
videos.each do |video|

  scene_id, vimeo_id = video[:scene_id], video[:vimeo_id]
  if scene_id.nil? || vimeo_id.nil?
     puts "No scene id or vimeo id in entry data: #{video.inspect}"
     next
  end
  url = "http://vimeo.com/#{video[:vimeo_id]}"

  # Compute filename (with no extension, we find that on the Vimeo page)
  filename = "#{sprintf('%03d',scene_id)}_#{vimeo_id}"
  puts "Scene #{scene_id}, vimeo_id #{vimeo_id} (#{filename}) ..."
  
  # Skip it if it exists already
  # TODO FIXME This is super slow..how to do File.exists? w/ a regex?! fnmatch+dir.read?. 
  # would rather do this than un-necessary HTTP fetches though...
  ['mov','avi','flv','mp4'].each do |ext|
    if File.exists?("#{output_dir}/#{filename}.#{ext}")
    # if File.fnmatch("#{filename}*", "#{output_dir}/#{filename}") #glob to match any extension? FIXME
      puts "File exists! Skipping..."
      break
      next
    end
  end
  
  # OK, proceed. Fetch Vimeo page, Get the link for the file
  puts "Getting: #{url}"
  page = agent.get(url)
  link = (page/'.file_extension a') # instead of .file_details, so we can grab 'MOV' text
  next if link.nil? || link.empty?
  href = link[0]['href']
  extension = link[0].content.downcase
  
  # Download the file. May timeout etc.
  begin
    output = "#{output_dir}/#{filename}.#{extension}"
    puts "Saving #{output}..."
    agent.get(href).save_as(output)
  rescue
    puts "Error: #{$!}"
  end
  
end

# My work here is done
exit 0

