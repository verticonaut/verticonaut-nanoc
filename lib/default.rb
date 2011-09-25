# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def base_color(detail_topic)
  case detail_topic
    when 'Climbing'
      'background: #BFBF99;'
    when 'Photography'
      'background: #7A9982;'
    when 'Projects'
      'background: #665C47;'
    when 'Thoughts'
      'background: #7F0026;'
    when 'About'
      'background: #E5B867;'
    else 'white'
  end
end

