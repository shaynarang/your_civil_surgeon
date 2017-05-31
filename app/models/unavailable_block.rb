class UnavailableBlock < ApplicationRecord
  def formatted_time time
    read_attribute(time) ? read_attribute(time).strftime('%I:%M%p') : nil
  end

  def start_time
    formatted_time(:start_time)
  end

  def end_time
    formatted_time(:end_time)
  end
end
