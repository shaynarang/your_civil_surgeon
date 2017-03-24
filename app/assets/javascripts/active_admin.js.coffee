#= require active_admin/base
#= require moment
#= require fullcalendar

$ ->

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
