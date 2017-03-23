class Patient < ApplicationRecord
  has_many :medical_records
  has_many :appointments
end
