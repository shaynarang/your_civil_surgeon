class MedicalRecordsController < ApplicationController
  def download
    medical_record = MedicalRecord.find(params[:id])
    scan = medical_record.scan
    return unless scan && scan.try(:file).exists?
    path = Rails.env.production? ? open(scan.file.url) : scan.path
    send_file(path,
          :filename => scan.path.split('/').last,
          :type => scan.file.content_type,
          :disposition => 'attachment',
          :url_based_filename => false)
  end
end

