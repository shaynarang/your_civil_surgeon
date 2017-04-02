#= require moment
#= require fullcalendar
#= require jquery.timepicker.min.js

$(document).ready ->

  # obtain the url
  split_path = window.location.pathname.split('/')

  # stop if the current page is not an appointments page
  return unless $('body').hasClass('admin_appointments')

  # establish current page
  if $('body').hasClass('new') || $('body').hasClass('create')
    page = 'new'
  else if $('body').hasClass('edit') || $('body').hasClass('update')
    page = 'edit'
  else
    page = 'index'

  # obtain search parameters
  search_params = new URLSearchParams(window.location.search)

####################################################################################

  # INDEX PAGE

  if page == 'index'
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
      editable: true
      eventDrop: (event) ->
        rescheduleAppointment(event)
      eventMouseover: (event, jsEvent) ->
        if event.description
          content = event.description
        else
          content = ''
        $(this).popover
            title: event.title,
            trigger: 'manual',
            content: content,
            container: '#calendar'
            placement: 'top'
        .popover('toggle')
      eventMouseout: (event, jsEvent) ->
        $(this).popover('hide')

    # replace full calendar link names
    $('.fc-today-button').html 'Back To Today'
    $('.fc-month-button').html 'Month'
    $('.fc-listWeek-button').html 'Week'
    $('.fc-listDay-button').html 'Day'

    disableAppointmentEdit = (patient_id) ->
      $.each $('a.fc-day-grid-event'), (_index, value) ->
        edit_link = new URL($(this).attr('href'))
        edit_link_params = new URLSearchParams(edit_link.search.slice(1));
        editPatientId = edit_link_params.get('patient_id')

        if patient_id != editPatientId
          $(this).attr('href', '').css(
            {
              'cursor': 'pointer',
              'pointer-events' : 'none'
            }
          )
        else
          href = $(this).attr('href')
          updated_href = href.slice(0, href.lastIndexOf('&'))
          $(this).attr('href', updated_href)

    directToNewAppointment = ->
      # direct user to new appointments upon calendar day click
      $(document).on 'click', '.fc-day-top', ->

        date = $(this).data('date')
        date_query = '?date=' + date

        link = '/admin/appointments/new' + date_query

        if search_params.has('patient_id')
          patient_id = search_params.get('patient_id')
          patient_query = '&patient_id=' + patient_id
          window.location.href = link + patient_query
        else
          window.location.href = link

    setUpCalendar = ->
      if search_params.has('patient_id')
        patient_id = search_params.get('patient_id')
        # disable edit for other patients
        disableAppointmentEdit(patient_id)
        # add cursor for new appointments
        $('td.fc-day-top').css('cursor', 'pointer')
        # direct user to new appointments upon calendar day click
        directToNewAppointment()

    if search_params.has('date')
      date = search_params.get('date')
      $('#calendar').fullCalendar('gotoDate', date)

    rescheduleAppointment = (event) ->
      id = event.id
      date = event.start.format()
      $.ajax
        url: '/appointments/' + id + '?date=' + date
        type: 'PATCH'
        contentType: 'application/json'
        xhr: ->
          if window.XMLHttpRequest == null or (new (window.XMLHttpRequest)).addEventListener == null then new (window.ActiveXObject)('Microsoft.XMLHTTP') else $.ajaxSettings.xhr()

####################################################################################

  # NEW/EDIT PAGES

  if page == 'new' || page == 'edit'
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

    date = $('#appointment_date').val()
    # get available times for date
    getAppointments(date)

    resetAppointments = ->
      # reset appointment times
      $('#appointment_time').val('')
      # grab selected date
      date = $('#appointment_date').val()
      # get unavailable times for date
      getAppointments(date)

    $('#appointment_date').change ->
      resetAppointments()

    patient_agnostic = search_params.get('patient_agnostic')
    if !patient_agnostic
      if search_params.has('patient_id')
        # grab the id of the selected patient
        patient_id = search_params.get('patient_id')
        # add patient_id parameter to cancel button
        $('li.cancel a').attr('href', '/admin/appointments?patient_id=' + patient_id)

####################################################################################

  if page == 'new'
    date = search_params.get('date')
    if date
      # prepopulate date field
      $('#appointment_date').val(date)
      # disable appropriate times
      getAppointments(date)

    patient_id = search_params.get('patient_id')
    if patient_id
      # prepopulate patient_id field
      $('#appointment_patient_id').val(patient_id).trigger('change')
      # $('option[value=' + patient_id + ']', '#appointment_patient_id').attr('selected', true)
