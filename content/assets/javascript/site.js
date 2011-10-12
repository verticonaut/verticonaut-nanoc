$(document).ready(function(){

  $('a:not(:has(img,div)), a[rel="ext"]').filter(function() {
      return this.hostname && this.hostname !== location.hostname;
  }).after(' <img src="/assets/img/12px/external_link_blue_light.png" alt="external link"/>');

});