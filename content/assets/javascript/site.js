$(document).ready(function(){

  $('a:not(:has(img))').filter(function() {
      return this.hostname && this.hostname !== location.hostname;
  }).after(' <img src="/assets/img/12px/external_link.png" alt="external link"/>');

});