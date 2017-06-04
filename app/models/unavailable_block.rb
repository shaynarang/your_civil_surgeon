class UnavailableBlock < ApplicationRecord

  validates_presence_of :start_date, :end_date, :start_time, :end_time

  validate :end_date_after_start_date?

  scope :contains_date, -> (date) { where('start_date <= ? AND end_date >= ?', date, date) }

  def formatted_time time
    read_attribute(time) ? read_attribute(time).strftime('%I:%M%p') : nil
  end

  def start_time
    formatted_time(:start_time)
  end

  def end_time
    formatted_time(:end_time)
  end

  def start_date_time
    (start_date.to_s + " " + start_time.to_s).to_datetime
  end

  def end_date_time
    (end_date.to_s + " " + end_time.to_s).to_datetime
  end

  def time_range
    [start_time, end_time]
  end

  def self.generate_series_identifer
    begin
      series_identifier = SecureRandom.hex
    end while self.exists?(series_identifier: series_identifier)
    series_identifier
  end

  private

  def end_date_after_start_date?
    if end_date < start_date
      errors.add :end_date, 'must be after start date'
    end
  end
end
