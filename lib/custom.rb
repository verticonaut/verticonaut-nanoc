def fetch_galleries
  @site[:galleries] ||= @site.items.
    select {|i| i.identifier =~ /photography\/galleries\/.*\/_meta/}.
    sort_by {|i| -1 * (i[:year]*100 + i[:month])}
end

class Constants
  MONTH = %w(- Jan Feb Mar Apr Mai Jun Jul Aug Sep Oct Nov Dec)
end
