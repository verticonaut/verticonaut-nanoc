# This contains routines for sorting the pages.

require 'set'
require 'time'

MONTHS = {
  1 => "January", 2 => "February", 3 => "March",
  4 => "April", 5 => "May", 6 => "June",
  7 => "July", 8 => "August", 9 => "September",
  10 => "October", 11 => "November", 12 => "December"
}
  
def tag_set(key)
  @site[:tags] ||= {}
  @site[:tags][:key]
end

def add_tag_set(key, tags)
  @site[:tags] ||= {}
  @site[:tags][:key] = tags
end

def collect_items
  @site.items.select {|i| yield(i) }
end

def collect_item_tags(key, items)
  # build tags
  tags = Set.new
  items.each do |i|
    (i[:tags] || []).each do |tag|
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

def create_gallery_tag_items
  tag_set(:galleries).each do |tag|
    create_item "/photography/tags/#{tag}/",
      :tag          => tag,
      :layout       => 'gallery_tag_page',
      :title        => 'Photography',
      :'base-color' => '#94b394',
      :stylesheet   => 'galleries'
  end
end



def collect_chrono
  years = Set.new
  months = {}
  articles.each do |i|
    cdate = i[:created_at]
    years.add(cdate.year)
    (months[cdate.year] ||= Set.new).add(cdate.month)
  end
  months.each do |k, v|
    months[k] = v.to_a.sort
  end
  @site[:years] = years.to_a.sort
  @site[:months] = months
end

def create_tag_items
  @site[:tags].each do |tag|
    create_item "/tags/#{tag}/", :tag => tag, :layout => "tag_page",
                                 :title => "Articles tagged #{tag}"
  end
end

def create_chrono_items
  @site[:years].each do |year|
    create_item "/#{year}/", :year => year, :layout => "year_page",
                             :title => "Articles from #{year}"
    @site[:months][year].each do |month|
      create_item "/#{year}/#{month}/", :year => year, :month => month,
                                        :layout => "month_page",
                                        :title => "Articles from #{MONTHS[month]} #{year}"
    end
  end
end

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

def gallery_tag_cloud(key)
  cloud = []
  tag_set(key).each do |tag|
    cloud << CloudTag.new(tag, gallery_items_with_tag(tag).length)
  end
  cloud
end

def canonicalize_years
  @items.each do |i|
    ctime = i[:created_at]
    i[:created_at] = Time.parse(ctime) if ctime.is_a?(String)
  end
end

def articles_for_year (year)
  articles.select { |i| i[:created_at].year == year }
end

def articles_for_month (year, month)
  articles.select do |i|
    cdate = i[:created_at]
    cdate.year == year && cdate.month == month
  end
end

