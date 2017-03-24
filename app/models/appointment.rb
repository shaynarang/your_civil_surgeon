class Appointment < ApplicationRecord
  belongs_to :patient

  validates_presence_of :date, :time, :patient_id

  def time
    read_attribute(:time) ? read_attribute(:time).strftime('%I:%M%p') : nil
  end

  def date_time
    (date.to_s + " " + time.to_s).to_datetime
  end
end
