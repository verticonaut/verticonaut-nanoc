# This contains routines for sorting the pages.

require 'set'
require 'time'

MONTHS = {
  1 => "January", 2 => "February", 3 => "March",
  4 => "April", 5 => "May", 6 => "June",
  7 => "July", 8 => "August", 9 => "September",
  10 => "October", 11 => "November", 12 => "December"
}

TagWhiteList = [
  "b&w",
  "analog",
  "animal",
  "climbing",
  "closeup",
  "culture",
  "detail",
  "experimental",
  "hiking",
  "landscape",
  "lifestyle",
  "nature",
  "panorama",
  "portrait",
  "sports",
  "still life",
  "travel",
  "hdr",
  "everyday life",
  "fun",
  "iphone",
  "hipstamatic",
  "360",
]

  
def tag_set(key)
  @site[:tags] ||= {}
  @site[:tags][key]
end

def add_tag_set(key, tags)
  @site[:tags] ||= {}
  @site[:tags][key] = tags
end

def collect_items
  @site.items.select {|i| yield(i) }
end

def collect_item_tags(key, items)
  # build tags
  tags = Set.new
  items.each do |item|
    item_tags = block_given? ? yield(item) : item[:tags]
    (item_tags || []).each do |tag|
      tags.add(tag)
    end
  end

  # store tags
  add_tag_set(key, tags.to_a.sort)
end

def collect_gallery_items
  collect_items do |item|
    %w[gallery featured_gallery].include? item[:kind]
  end
end

def collect_gallery_tags
  items = collect_gallery_items
  collect_item_tags(:galleries, items)
end

def gallery_items_with_tag(tag)
  collect_gallery_items.
    select {|i| (i[:tags] || []).include?(tag)}.
    sort_by {|i| -1 * (i[:year] ? (i[:year]*100 + i[:month]) : -1)}
end

def image_items_with_tag(tag)
  collect_image_items.
    select {|i| (i[:tags] || []).any?{|image_tag| image_tag.downcase == tag} }.
    sort_by {|i| -1 * (i[:year] ? (i[:year]*100 + i[:month]) : -1)}
end

def create_gallery_tag_items
  tag_set(:galleries).each do |tag|
    create_item "/photography/galleries/tagged/#{tag}/",
      :tag          => tag,
      :layout       => 'gallery_tag_page',
      :title        => "Photography",
      :'base-color' => '#94b394',
      :stylesheet   => 'galleries'
  end
end

def collect_image_tags
  items = collect_image_items

  @site[:tag_image_cache] = {}
  all_tags = Set.new
  collect_item_tags(:gallery_images, items) do |item|
    img = EXIFR::JPEG.new(item.raw_filename)
    xmp = XMP.parse(img)

    begin
      tags = (xmp.dc.subject || []).map(&:downcase)
      all_tags = all_tags | tags
      tags.select! {|ele| TagWhiteList.include? ele }
    rescue => e
      puts "*" * 100
      # puts e.stacktrace
      tags = []
    end

    tags.each do |tag|
      (@site[:tag_image_cache][tag] ||= []) << item
    end
  end

  # log all tags - so we can extend the white list in case new reasonalbe ones come up
  puts "*" * 50
  puts :all_tags => all_tags.to_a.join(',')
end

def collect_image_items
  collect_items do |item|
    item.identifier =~ /photography\/galleries\/[^\/]+\/image-\d*/
  end
end

def create_image_tag_items
  tag_set(:gallery_images).each do |tag|
    create_item "/photography/images/tagged/#{tag}/",
      :tag          => tag,
      :layout       => 'image_tag_page',
      :title        => "Images tagged '#{tag}'",
      :'base-color' => '#94b394',
      :stylesheet   => 'galleries'
  end
end

def gallery_tag_cloud
  cloud = []
  tag_set(:galleries).each do |tag|
    cloud << CloudTag.new(tag, gallery_items_with_tag(tag).length)
  end
  cloud
end

def image_tag_cloud
  cloud = []
  tag_set(:gallery_images).each do |tag|
    cloud << CloudTag.new(tag, @site[:tag_image_cache][tag].length)
  end
  cloud
end



# ****************************************************************************

class CloudTag
  attr_accessor :name
  attr_accessor :count
  
  def initialize(name, count)
    @name = name
    @count = count
  end
  
  def size
    8 + (Math.log(@count).to_i) * 2
  end
end

