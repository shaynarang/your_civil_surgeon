class MedicalRecord < ApplicationRecord
  belongs_to :patient

  attr_accessor :_destroy_scan

  mount_uploader :scan, ScanUploader
end
