#= require active_admin/base

$(document).ready ->
  $('.datepicker').datepicker
    changeYear: true
    changeMonth: true
    yearRange: "1900:(new Date).getFullYear()"
  return