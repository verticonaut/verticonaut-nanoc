require 'json'
require 'xmp'
require 'exifr'
require 'open-uri'

def fetch_galleries
  @site[:galleries] ||= @site.items.
    select {|i| i.identifier =~ /photography\/galleries\/\d{4}-.*\/_meta/}.
    sort_by {|i| -1 * (i[:year]*100 + i[:month])}
  @site[:special_galleries] ||= @site.items.
    select {|i| i.identifier =~ /photography\/galleries\/_.*\/_meta/}.
    sort_by {|i| i[:position]}
end

def build_gallery_data(item)
  data = []
  path = item.path
  Dir.glob("content#{path}image*.jpg") do |file|
    filename = File.basename(file)
    file_nr = /.*\D+_?(\d+)\.jpg/i.match(filename) ? $1 : nil
    puts "invalid filename: #{filename}" unless file_nr

    # read image meta data
    img = EXIFR::JPEG.new(file)
    xmp = XMP.parse(img)
    # subject     = xmp.dc.subject.join(', ') #=> ["something interesting"]
    title       = xmp.dc.title.join(', ') #=> ["something interesting"]
    description = xmp.dc.description.join(', ') #=> ["something interesting"]
    begin
      city        = xmp.photoshop.City.content
      country     = xmp.photoshop.Country.content
      location    = (country && !country.strip.empty? && city && !city.strip.empty?) ? " (#{city}/#{country})" : ""
    rescue
      location = ""
    end
        
    data << {
        :thumb       => "#{path}/thumb#{file_nr}.jpg",
        :image       => "#{path}/image#{file_nr}.jpg",
        :big         => "#{path}/big#{file_nr}.jpg",
        :title       => title,
        :description => "description#{location}",
        :link        => 'http://my.destination.com',
        :_layer      => '<div><h2>This image is gr8</h2><p>And this text will be on top of the image</p>'
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

def gallery_target(gallery_item)
  if (url = gallery_item[:url]) then
    "_blank"
  else
    ""
  end
end

def galleries_url
  "/detail/photography"
end

class Constants
  MONTH = %w(- Jan Feb Mar Apr Mai Jun Jul Aug Sep Oct Nov Dec)
end
