#= require active_admin/base
#= require moment
#= require fullcalendar
#= require jquery.timepicker.min.js

$(document).ready ->
  $('#calendar').fullCalendar
    header: {
              left: 'prev,next today',
              center: 'title',
              right: 'month,basicWeek,basicDay'
            }
    events: '/appointments.json'

  $('.datepicker').datepicker
    changeYear: true
    changeMonth: true
    yearRange: "1900:(new Date).getFullYear()"
    dateFormat: 'yy-mm-dd'

  $('.timepicker').timepicker()