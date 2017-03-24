json.array!(@appointments) do |appointment|
  json.id appointment.id
  json.title appointment.patient.name
  json.description appointment.notes
  json.start appointment.date_time
  json.url admin_appointment_url(appointment, format: :html)
end