#= require active_admin/base
#= require moment
#= require fullcalendar
#= require jquery.timepicker.min.js

$(document).ready ->

  # datepicker config
  $('.datepicker').datepicker
    changeYear: true
    changeMonth: true
    yearRange: "1900:(new Date).getFullYear()"
    dateFormat: 'yy-mm-dd'

  # timepick with optional disable ranges
  timePick = (disable_ranges) ->
    disable_ranges = disable_ranges || []

    # block off lunch hour
    disable_ranges.push ['12pm', '1pm']

    # timepicker config
    $('.timepicker').timepicker
      minTime: '9:00am',
      maxTime: '4:00pm',
      disableTimeRanges:
        disable_ranges

  # timepick without disable range
  timePick()

  # fullcalendar config
  $('#calendar').fullCalendar
    header: {
              left: 'prev,next today',
              center: 'title',
              right: 'month,listWeek,listDay'
            }
    events: '/appointments.json'

  # replace full calendar link names
  $('.fc-today-button').html 'Back To Today'
  $('.fc-month-button').html 'Month'
  $('.fc-listWeek-button').html 'Week'
  $('.fc-listDay-button').html 'Day'

  # direct user to new appointments upon calendar day click
  $(document).on 'dblclick', '.fc-day', ->
    date = $(this).data('date')
    window.location.href = '/admin/appointments/new?date=' + date

  # http://stackoverflow.com/questions/17446466/add-15-minutes-to-string-in-javascript
  addMinutes = (time, minsToAdd) ->

    D = (J) ->
      (if J < 10 then '0' else '') + J

    piece = time.split(':')
    mins = piece[0] * 60 + +piece[1] + +minsToAdd
    D(mins % 24 * 60 / 60 | 0) + ':' + D(mins % 60)

  # obtain unavailable times for date
  getUnavailableTimes = (appointments) ->
    unavailable_times = []
    $.each appointments, (_key, value) ->
      time_range = value['time_range']
      unavailable_times.push time_range
    # pass unavailable times to timepicker
    timePick(unavailable_times)

  # get appointments for date
  getAppointments = (date) ->
    $.ajax(
        url: '/appointments?date=' + date
      )
      .done (data) ->
        getUnavailableTimes(data)
      .fail ->
        console.log('fail!')
        return

  # prepopulate new appointment date if necessary

  # obtain the url
  split_path = window.location.pathname.split('/')
  # stop if the current page is not an appointments page
  return if split_path.indexOf('appointments') < -1
  # stop if the current page is not a new page
  return if split_path.indexOf('new') < -1

  # grab the url parameters
  searchParams = new URLSearchParams(window.location.search)
  searchParams.has('date')
  date = searchParams.get('date')
  if date
    # prepopulate date field
    $('#appointment_date').val(date)
    # disable appropriate times
    getAppointments(date)
