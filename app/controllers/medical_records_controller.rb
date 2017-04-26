class MedicalRecordsController < ApplicationController
  def download
    medical_record = MedicalRecord.find(params[:id])
    scan = medical_record.scan
    return unless scan && scan.try(:file).exists?
    send_file(scan.file.url,
          :filename => scan.path.split('/').last,
          :type => scan.file.content_type,
          :disposition => 'attachment',
          :url_based_filename => false)
  end
end

