#= require moment
#= require fullcalendar
#= require jquery.timepicker.min.js

$(document).ready ->

  # obtain the url
  split_path = window.location.pathname.split('/')

  # stop if the current page is not an appointments page
  return if split_path.indexOf('appointments') == -1

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
    disable_ranges.push ['12:00pm', '1:00pm']

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
    loading: (bool) ->
      if bool
        console.log('Loading calendar...')
      else
        console.log('Great success.')
        setUpCalendar()

  # replace full calendar link names
  $('.fc-today-button').html 'Back To Today'
  $('.fc-month-button').html 'Month'
  $('.fc-listWeek-button').html 'Week'
  $('.fc-listDay-button').html 'Day'

  disableAppointmentEdit = (patient_id) ->
    $.each $('a.fc-day-grid-event'), (_index, value) ->
      editLink = new URL($(this).attr('href'))
      editLinkParams = new URLSearchParams(editLink.search.slice(1));
      editPatientId = editLinkParams.get('patient_id')

      if patient_id != editPatientId
        $(this).attr('href', '').css(
          {
            'cursor': 'pointer',
            'pointer-events' : 'none'
          }
        )

  directToNewAppointment = ->
    # direct user to new appointments upon calendar day click
    $(document).on 'click', '.fc-day', ->

      date = $(this).data('date')
      date_query = '?date=' + date

      link = '/admin/appointments/new' + date_query

      searchParams = new URLSearchParams(window.location.search)
      if searchParams.has('patient_id')
        # obtain patient_id
        patient_id = searchParams.get('patient_id')
        patient_query = '&patient_id=' + patient_id

      if patient_query
        window.location.href = link + patient_query
      else
        window.location.href = link

  setUpCalendar = ->
    # check search params
    searchParams = new URLSearchParams(window.location.search)
    # if patient_id parameter is available
    if searchParams.has('patient_id')
      patient_id = searchParams.get('patient_id')
      # disable edit for other patients
      disableAppointmentEdit(patient_id)
      # add cursor for new appointments
      $('td.fc-day').css('cursor', 'pointer')
      # direct user to new appointments upon calendar day click
      directToNewAppointment()

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

  # if the current page is the new appointment page
  if split_path.indexOf('new') > -1
    # grab the url parameters
    searchParams = new URLSearchParams(window.location.search)

    if searchParams.has('date')
      # obtain date value
      date = searchParams.get('date')
      # prepopulate date field
      $('#appointment_date').val(date)
      # disable appropriate times
      getAppointments(date)

    if searchParams.has('patient_id')
      # obtain patient_id value
      patient_id = searchParams.get('patient_id')
      # prepopulate patient_id field
      $('#appointment_patient_id').val(patient_id).trigger('change')
      # $('option[value=' + patient_id + ']', '#appointment_patient_id').attr('selected', true)

  $(document).on 'change', '#appointment_date', ->
    # reset appointment times
    $('#appointment_time').val('')
    # grab selected date
    date = $(this).val()
    # get available times for date
    getAppointments(date)

  if split_path.indexOf('new') > -1 || split_path.indexOf('edit') > -1
    # grab the id of the selected patient
    patient_id = $('#appointment_patient_id').val()
    # add patient_id parameter to cancel button
    $('li.cancel a').attr('href', '/admin/appointments?patient_id=' + patient_id)

    # grab selected date
    date = $(this).val()
    # get available times for date
    getAppointments(date)

  # retain calendar position via date parameter
  searchParams = new URLSearchParams(window.location.search)
  if searchParams.has('date')
    date = searchParams.get('date')
    $('#calendar').fullCalendar('gotoDate', date)
