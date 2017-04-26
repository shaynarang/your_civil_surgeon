class MedicalRecordsController < ApplicationController
  def download
    medical_record = MedicalRecord.find(params[:id])
    scan = medical_record.scan
    return unless scan && scan.try(:file).exists?
    patient_id = medical_record.patient_id
    date_of_service = medical_record.date_of_service
    kind = medical_record.kind.downcase
    filename = "#{patient_id}_#{date_of_service}_#{kind}"
    send_file(scan.url,
          :filename => filename,
          :type => scan.file.content_type,
          :disposition => 'attachment',
          :url_based_filename => true)
  end
end

