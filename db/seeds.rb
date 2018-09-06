# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Admin.exists?(email: 'admin@example.com')
  Admin.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end

def appointment_time
  a = %w(9 10 11 12 1 2 3 4)
  b = %w(00 15 30 45)
  hour = a.sample
  minute = b.sample
  "#{hour}:#{minute}#{hour.to_i.between?(9, 11) ? 'am' : 'pm'}"
end

def appointment_date
  "#{Date.today + (rand * 90)}"
end

def appointment_patient_id
  Patient.order('RANDOM()').first.id
end

def appointment_notes
  sentence = ''

  words = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id lectus nibh. Etiam ut pharetra turpis. Nam eget tristique dui, eget elementum arcu. Suspendisse maximus commodo dui non cursus. Mauris ac blandit massa. Pellentesque non euismod justo. Suspendisse vehicula arcu erat, vel congue nisi sollicitudin sit amet. Cras sapien sem, convallis eget odio et, consequat dictum lorem. Fusce et justo rhoncus, consectetur magna et, tincidunt lectus. Sed molestie metus ipsum. Integer iaculis, purus ut sodales porttitor, urna arcu volutpat leo, ut venenatis dolor neque sed nisl. Fusce a quam quis ex auctor lacinia. Curabitur tempus dolor turpis, in consequat lorem feugiat vel. Integer quis tellus risus.'

  10.times do
    sentence << words.split(/\W+/).sample + ' '
  end

  sentence.capitalize.strip << '.'
end

counter = 0
until counter == 1000
  date = appointment_date
  time = appointment_time
  unless Appointment.exists?(date: date, time: time)
    appointment = Appointment.create(
      date: date,
      time: time,
      patient_id: appointment_patient_id,
      notes: appointment_notes,
      status: 'Scheduled'
    )
    puts "Appointment #{appointment.id} created!"
    counter += 1
  end
end