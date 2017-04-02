#= require active_admin/base
#= require select2-full
#= require bootstrap/bootstrap-rails-tooltip
#= require bootstrap/bootstrap-rails-popover

$ ->
  # initiate select 2
  $('select').select2()

  # datepicker config
  $('.datepicker').datepicker
    changeYear: true
    changeMonth: true
    yearRange: "1900:(new Date).getFullYear()"
    dateFormat: 'yy-mm-dd'

  # index table row redirect to show
  $('tr.odd > td:not(:last-of-type), tr.even > td:not(:last-of-type)').click ->
    link = $(this).parent().find('td.col-actions a.view_link').prop('href')
    window.location = link

  # highlight all columns except for edit column
  $('tr.odd > td:not(:last-of-type), tr.even > td:not(:last-of-type)').hover (->
    $(this).parent().find('td:not(:last-child)').addClass 'highlight'
    return
  ), ->
    $(this).parent().find('td:not(:last-child)').removeClass 'highlight'
    return

  # highlight only selected edit td
  $('td.col-actions').hover (->
    $(this).addClass('highlight')
  ), ->
    $(this).removeClass('highlight')

  # redirect to resource edit upon click of td
  $('td.col-actions').click ->
    link = $(this).find('a.edit_link').prop('href')
    window.location = link