def fetch_galleries
  @site[:galleries] ||= @site.items.
    select {|i| i.identifier =~ /photography\/galleries\/.*\/_meta/}.
    sort_by {|i| -1 * (i[:year] + i[:month])}
end
