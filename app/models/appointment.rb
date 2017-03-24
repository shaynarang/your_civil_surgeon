class Appointment < ApplicationRecord
  belongs_to :patient

  def time
    super.strftime('%I:%M%p') unless new_record?
  end

  def date_time
    (date.to_s + " " + time.to_s).to_datetime
  end
end
