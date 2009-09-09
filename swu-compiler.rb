require 'rubygems'
require 'mechanize'

agent = WWW::Mechanize.new
agent.user_agent = "Star Wars Uncut Assemblotron <http://jamiedubs.com>"


# Start
url = "http://vimeo.com/videos/search:Star%20Wars%20Uncut"
puts "Fetching #{url.inspect} ..."
page = agent.get(url)
array = []

# Grab all vids on this page, then recurse
while true do
  links = (page/'.title a')
  links.map { |link| 
    store = { :title => link.content, :url => "http://vimeo.com#{link['href']}" } 
    puts "Storing: #{store.inspect}"
    array << store
  }
  
  # Go to next page
  suivant = page.links.select { |v| 
    v.href =~ /page/ && v.to_s == "next"
  }.compact.last rescue nil
  puts "Next page = #{suivant.href rescue 'NIL'}"
  
  if suivant
    # sleep 1 # Be nice(ish)
    page = suivant.click
  else
    puts "No next button! Abort"
    break
  end    
end


# Save output yaml
filename = "swu.yml"
File.open(filename, 'w') { |out| YAML.dump(array, out) }

exit 0