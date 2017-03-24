#= require active_admin/base
#= require moment
#= require fullcalendar
#= require jquery.timepicker.min.js

$(document).ready ->
  $('#calendar').fullCalendar
    header: {
              left: 'prev,next today',
              center: 'title',
              right: 'month,listWeek,listDay'
            }
    events: '/appointments.json'

  $('.fc-today-button').html 'Back To Today'
  $('.fc-month-button').html 'Month'
  $('.fc-listWeek-button').html 'Week'
  $('.fc-listDay-button').html 'Day'

  $('.datepicker').datepicker
    changeYear: true
    changeMonth: true
    yearRange: "1900:(new Date).getFullYear()"
    dateFormat: 'yy-mm-dd'

  $('.timepicker').timepicker
    minTime: '9:00am',
    maxTime: '4:00pm',
    disableTimeRanges: [
      ['12pm', '1pm']
    ]