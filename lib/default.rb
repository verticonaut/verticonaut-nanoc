
# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Tagging

class Nanoc3::Site
  attr_accessor :memory

  def [] (key)
    @memory[key]
  end

  def []= (key, value)
    @memory[key] = value
  end
end

def create_item (identifier, metadata)
  content = metadata.has_key?(:content) ? metadata.delete(:content) : ""
  @site.items << Nanoc3::Item.new(content, metadata, identifier)
end

def pluralize (n, singular, plural)
  n == 1 ? "#{n} #{singular}" : "#{n} #{plural}"
end

