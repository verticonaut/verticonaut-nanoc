require 'json'

def fetch_galleries
  @site[:galleries] ||= @site.items.
    select {|i| i.identifier =~ /photography\/galleries\/.*\/_meta/}.
    sort_by {|i| -1 * (i[:year]*100 + i[:month])}
end

def build_gallery_data(item)
  data = []
  path = item.path
  Dir.glob("content#{path}normal*.jpg") do |file|
    filename = File.basename(file)
    file_nr = /.*\D+_?(\d+)\.jpg/i.match(filename) ? $1 : nil
    puts "invalid filename: #{filename}" unless file_nr
    
    data << {
        :thumb       => "#{path}/thumb#{file_nr}.jpg",
        :image       => "#{path}/normal#{file_nr}.jpg",
        :big         => "#{path}/large#{file_nr}.jpg",
        :title       => 'My title',
        :description => 'My description',
        :link        => 'http://my.destination.com',
        :layer       => '<div><h2>This image is gr8</h2><p>And this text will be on top of the image</p>'
    } if file_nr
  end

  data
end

def gallery_url(gallery_item)
  if (url = gallery_item[:url]) then
    url
  else
    gallery_item.path
  end
end

class Constants
  MONTH = %w(- Jan Feb Mar Apr Mai Jun Jul Aug Sep Oct Nov Dec)
end
