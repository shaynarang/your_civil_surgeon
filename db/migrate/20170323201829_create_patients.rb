class CreatePatients < ActiveRecord::Migration[5.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.string :sex
      t.date :date_of_birth
      t.string :city_of_origin
      t.string :country_of_origin
      t.string :alien_registration_number
      t.string :uscis_online_account_number
      t.string :email
      t.string :primary_phone
      t.string :alternate_phone
      t.string :email
      t.text :additional_notes
      t.string :interpreter_business_name
      t.string :interpreter_first_name
      t.string :interpreter_last_name
      t.string :interpreter_email
      t.string :interpreter_phone

      t.timestamps
    end
  end
end
