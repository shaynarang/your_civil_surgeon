class Patient < ApplicationRecord
  has_many :medical_records
  has_many :appointments

  validates_presence_of :first_name, :last_name, :date_of_birth

  def name
    "#{last_name}, #{first_name} #{middle_name}".truncate(50).strip
  end
end
