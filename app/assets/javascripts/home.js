$(document).ready(function() {
  $('#map').click(function () {
    $('#map iframe').css('pointer-events', 'auto');
  });
  
  $( '#map' ).mouseleave(function() {
    $('#map iframe').css('pointer-events', 'none');
  });

  $('.section').fadeIn('slow');

  // $('.nav_link').on('click', function() {
  //   var section = $(this).data('section');
  //   element = $('.section' + '#' + section)
  //   $('html, body').animate({
  //     scrollTop: element.offset().top
  //   }, 2000);
  // });
});  