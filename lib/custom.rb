def fetch_galleries
  @site[:galleries] ||= @site.items.select {|i| i.identifier =~ /photography\/galleries/}
end
