class Appointment < ApplicationRecord
  belongs_to :patient

  def friendly_time
    time.strftime('%I:%M%p') if time
  end
end
