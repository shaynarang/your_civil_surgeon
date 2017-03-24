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

  $(document).on 'dblclick', '.fc-day', ->
    date = $(this).data('date')
    window.location.href = '/admin/appointments/new?date=' + date

    # the following script only applies to the new appointments page

    # obtain the url
    split_path = window.location.pathname.split('/')

    # stop if the current page is not an appointments page
    return if split_path.indexOf('appointments') < -1

    # stop if the current page is not a new page
    return if split_path.indexOf('new') < -1

    searchParams = new URLSearchParams(window.location.search)
    searchParams.has('date')
    date = searchParams.get('date')
    if date
      $('#appointment_date').val date
