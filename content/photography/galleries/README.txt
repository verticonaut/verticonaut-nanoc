**************************************************************************************************
*** README
**************************************************************************************************


*** How to build a featured gallery like HDR or Favorites.
**************************************************************************************************
  - name the folder '_yourName' - e.g. _hdr
  - put a metadata file named '_meta.html.haml' with the content like:
      --- 
      gallery_title: HDR Photography
      _url: http://statics.through-the-lens.ch/galleries/2002_12_patagonia
      layout: js_gallery
      text: description should come here ....
      position: 2
      ---
    
    Note: Omit the attribute :year, it's used as switch to render the render the date box

  - Add a file named _splash.jpg to the directory which is used as minified icon on the overview
  - Add all file named something_[thumb|image|big]_ddd.jpg with respective content of quality 70%
    - the images should be around x * x px
    - the 'thumb' images should be around x * x px
    - the 'big' images should be around x * x px
      



*** How to build a regualar gallery like 2011-04-mytrip.
**************************************************************************************************

  - name the folder 'yyyy-mm-youName' - e.g. '2011-04-mytrip'
  - put a metadata file named '_meta.html.haml' with the content like:
      --- 
      gallery_title: HDR Photography
      _url: http://statics.through-the-lens.ch/galleries/2002_12_patagonia
      year: 2011
      month: 03
      layout: js_gallery
      text: description should come here ....
      ---
    
    Note: Omit the attribute :year, month: is used for ordering (descending)

  - Add a file named _splash.jpg to the directory which is used as minified icon on the overview
  - Add all file named something_[thumb|image|big]_ddd.jpg with respective content of quality 70%
    - the images should be around x * x px
    - the 'thumb' images should be around x * x px
    - the 'big' images should be around x * x px
