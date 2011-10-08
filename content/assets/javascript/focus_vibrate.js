$(document).ready(function(){

  // twitter news slide panel
  $("#slide-trigger").click(function(){
      $("#slide-panel").toggle("fast");

      return false;
  });

  $("#_slide-panel").mouseout(function() {
    $(this).toggle("fast");
  });

  $('#latest-tweets').jTweetsAnywhere({
    username: 'verticonaut',
    count: 5,
    showFollowButton: true
  });

  // vibrate stuff
  $('#splash .focus').mouseenter(function() {
    // ele is area to shiver
    var id = $(this).attr("data-shiver-id");
    var ele = $(id);
    ele.attr('data-mouse', 'shiver');
    ele.show();

    $(this).hide();
    
    // set menu item color
    var menu_ref = ele.attr('data-menu-item');
    $('.'+menu_ref).addClass(menu_ref + '-hover');

    // start shiver ele
    ele.vibrate({spread: 7, frequency: 1000, duration: 1000, speed: 50});
  });

  $('#menubar .focus').mouseenter(function() {
    var id = $(this).attr("data-shiver-id");
    var ele = $(id);
    ele.show();
    ele.vibrate({spread: 6, frequency: 1000, duration: 1000, speed: 50});
  });

  $('.shiver').mouseout(function() {
    var menu_ref = $(this).attr('data-menu-item');
    $('.'+menu_ref).removeClass(menu_ref + '-hover').addClass(menu_ref);

    if ($(this).attr('data-mouse')) {
      $(this).hide(); 
    }

    $('.focus').show();
  });

  $('#menubar .focus').mouseout(function() {
    var id = $(this).attr("data-shiver-id");
    $(id).hide();
  });
});
