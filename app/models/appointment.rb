class Appointment < ApplicationRecord
  belongs_to :patient

  validates_presence_of :date, :time, :patient_id

  def self.on_the_books
    statuses = ['Confirmed', 'Unconfirmed', nil]
    where(status: statuses)
  end

  def time
    read_attribute(:time) ? read_attribute(:time).strftime('%I:%M%p') : nil
  end

  def date_time
    (date.to_s + " " + time.to_s).to_datetime
  end

  def time_range
    end_time = read_attribute(:time) + 30.minutes
    [time, end_time.strftime('%I:%M%p')]
  end
end
