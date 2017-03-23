class CreateMedicalRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :medical_records do |t|
      t.string :kind
      t.string :scan
      t.belongs_to :patient, foreign_key: true

      t.timestamps
    end
  end
end
