class MedicalRecord < ApplicationRecord
  belongs_to :patient

  mount_uploader :scan, ScanUploader
end
