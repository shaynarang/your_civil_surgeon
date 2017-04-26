class Patient < ApplicationRecord
  has_many :medical_records
  has_many :appointments

  validates_presence_of :first_name, :last_name, :date_of_birth

  def name
    "#{last_name}, #{first_name} #{middle_name}".truncate(50).strip
  end

  def age
    # http://stackoverflow.com/questions/819263/get-persons-age-in-ruby/5951744
    now = Time.now.utc.to_date
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end

end
