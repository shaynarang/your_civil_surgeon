#= require active_admin/base
#= require moment
#= require fullcalendar

$(document).ready ->
  $('#calendar').fullCalendar();

  $('.datepicker').datepicker
    changeYear: true
    changeMonth: true
    yearRange: "1900:(new Date).getFullYear()"
    dateFormat: 'yy-mm-dd'
  return
