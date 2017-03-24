class Patient < ApplicationRecord
  has_many :medical_records
  has_many :appointments

  def name
    "#{last_name}, #{first_name} #{middle_name}"
  end
end
