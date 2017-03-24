#= require jquery.timepicker.min.js

$ ->

  # datepicker config
  $('.datepicker').datepicker
    changeYear: true
    changeMonth: true
    yearRange: "1900:(new Date).getFullYear()"
    dateFormat: 'yy-mm-dd'

  # timepicker config
  $('.timepicker').timepicker
    minTime: '9:00am',
    maxTime: '4:00pm',
    disableTimeRanges: [
      ['12pm', '1pm']
    ]