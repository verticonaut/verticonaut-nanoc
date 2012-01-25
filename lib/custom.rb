# encoding: utf-8

require 'json'
require 'xmp'
require 'exifr'
require 'open-uri'


def fetch_galleries
  @site[:galleries] ||= @site.items.
    select {|i| i.identifier =~ /photography\/galleries\/\d{4}-.*\/_meta/}.
    sort_by {|i| -1 * (i[:year]*100 + i[:month])}
  @site[:featured_galleries] ||= @site.items.
    select {|i| i[:kind] == 'featured_gallery'}.
    sort_by {|i| i[:position]}
end

def build_gallery_data(item)
  data = []
  path = item.path
  Dir.glob("content#{path}image-*.jpg") do |file|
    build_single_image_data(data, file, path)
  end

  data
end

def build_images_data(tag)
  data = []
  @site[:tag_image_cache][tag].each do |item|
    file = File.new(item.raw_filename)
    path = File.dirname(item.path)

    build_single_image_data(data, file, path)
  end

  data
end

def build_single_image_data(data, file, path)
  filename = File.basename(file)
  file_nr = /.*\D+-(\d+)\.jpg/i.match(filename) ? $1 : nil
  puts "invalid filename: #{filename}" unless file_nr

  # read image meta data
  img = EXIFR::JPEG.new(file)
  xmp = XMP.parse(img)

  headline    = ""
  desription  = ""
  tags        = ""
  city        = ""
  country     = ""
  location    = ""

  begin
    # tags (Inhalt: Schlagwoerter)
    tags = xmp.dc.subject.join(', ')
  rescue
    puts :tags => tags
  end

  begin
    # Inhalt: Überschrift
    headline = xmp.photoshop.Headline.content
  rescue => e
    # has no content
  end

  begin
    # Inhalt: Untertitel
    description = xmp.dc.description.join(', ')
  rescue => e
    # has no content
  end

  begin
    city = xmp.photoshop.City.content
  rescue => e
    # has no content
  end

  begin
    country = xmp.photoshop.Country.content
  rescue => e
    # has no content
  end

  begin
    location = (country && !country.strip.empty? && city && !city.strip.empty?) ? " (#{city}/#{country})" : ""
  rescue => e
    # has no content
  end

  data << {
    :thumb       => "#{path}/thumb-#{file_nr}.jpg",
    :image       => "#{path}/image-#{file_nr}.jpg",
    :big         => "#{path}/big-#{file_nr}.jpg",
    :title       => headline,
    :description => location,
    :layer       => description.nil? || description.empty? ? "" : "<div class='description'>#{description}</div>",
    :_link        => 'http://my.destination.com'
  } if file_nr
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

def marker_name(item)
  item.identifier.gsub('/', '_')
end

def galleries_url
  "/detail/photography"
end

class Constants
  MONTH = %w(- Jan Feb Mar Apr Mai Jun Jul Aug Sep Oct Nov Dec)
end
