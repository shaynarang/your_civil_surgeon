json.array!(@appointments) do |appointment|
  if appointment.class == Appointment
    json.id appointment.id
    json.title appointment.patient.name
    json.description appointment.notes
    json.start appointment.date_time
    json.end appointment.date_time
    json.time_range appointment.time_range
    json.url edit_admin_appointment_url(appointment) + "?patient_id=#{appointment.patient.id}&patient_agnostic=true"
  elsif appointment.class == UnavailableBlock
    json.id appointment.id
    json.title appointment.notes ? "UNAVAILABLE (#{appointment.notes})" : 'UNAVAILABLE'
    json.description appointment.notes
    json.start appointment.start_date_time
    json.end appointment.end_date_time
    json.time_range appointment.time_range
    json.url edit_admin_unavailable_block_url(appointment)
    json.color 'rgba(77, 82, 86, 0.65)'
  end
end