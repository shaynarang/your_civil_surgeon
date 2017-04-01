json.array!(@appointments) do |appointment|
  json.id appointment.id
  json.title appointment.patient.name
  json.description appointment.notes
  json.start appointment.date_time
  json.time_range appointment.time_range
  json.url edit_admin_appointment_url(appointment) + "?patient_id=#{appointment.patient.id}&patient_agnostic=true"
end