$(document).ready ->

  # obtain the url
  split_path = window.location.pathname.split('/')

  # stop if the current page is not a medical records page
  return if split_path.indexOf('medical_records') < -1

  # if the current page is the new appointment page
  if split_path.indexOf('new') > -1 || split_path.indexOf('edit') > -1 
    # grab the id of the selected patient
    patient_id = $('#medical_record_patient_id').val()
    # add patient_id parameter to cancel button
    $('li.cancel a').attr('href', '/admin/medical_records?patient_id=' + patient_id)
