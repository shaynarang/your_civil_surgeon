$(document).ready(function() {
  $('#map').click(function () {
      $('#map iframe').css("pointer-events", "auto");
  });
  
  $( "#map" ).mouseleave(function() {
    $('#map iframe').css("pointer-events", "none"); 
  });

  $('.section').fadeIn('slow')
});  