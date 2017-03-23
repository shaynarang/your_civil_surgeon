class AddDateOfServiceToMedicalRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :medical_records, :date_of_service, :date
  end
end
