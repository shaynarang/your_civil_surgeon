class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.date :date
      t.time :time
      t.belongs_to :patient, foreign_key: true
      t.text :notes
      t.string :status

      t.timestamps
    end
  end
end
