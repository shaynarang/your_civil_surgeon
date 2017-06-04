#= require jquery.timepicker.min.js

$(document).ready ->

  # obtain the url
  split_path = window.location.pathname.split('/')

  # stop if the current page is not an appointments page
  return unless $('body').hasClass('admin_unavailable_blocks')

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

  # timepicker config
  $('.timepicker').timepicker
    minTime: '9:00am',
    maxTime: '4:15pm',
    step: 15

  ####################################################################################

  if page == 'new'
    start_date = search_params.get('start_date')
    if start_date
      # prepopulate start date field
      $('#unavailable_block_start_date').val(start_date)
