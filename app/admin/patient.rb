ActiveAdmin.register Patient do
  menu priority: 1

  permit_params :first_name, :last_name, :middle_name, :street1, :street2, :city, :state, :zip, :sex, :date_of_birth, :city_of_origin, :country_of_origin, :alien_registration_number, :uscis_online_account_number, :email, :primary_phone, :alternate_phone, :additional_notes, :interpreter_business_name, :interpreter_first_name, :interpreter_last_name, :interpreter_email, :interpreter_phone

  filter 'last_name_cont', :label => 'Last Name'
  filter 'first_name_cont', :label => 'First Name'
  filter :date_of_birth
  filter 'primary_phone_or_alternate_phone_cont', :label => 'Phone', :as => :string

  action_item :only => [:edit, :show] do
    link_to 'Medical Records', admin_medical_records_path(patient_id: patient.id)
  end

  action_item :only => [:edit, :show] do
    link_to 'Make Appointment', admin_appointments_path(patient_id: patient.id)
  end

  config.sort_order = 'last_name_asc'

  index :download_links => false do
    id_column
    column :last_name
    column :first_name
    column :date_of_birth
    actions name: 'Edit'
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    br
    f.inputs 'Patient Demographics' do
      f.input :first_name
      f.input :last_name
      f.input :middle_name
      f.input :sex, :as => :select, :collection => ['Male', 'Female', 'Other', 'Unknown']
      f.input :date_of_birth, :as => :datepicker
      f.input :city_of_origin
      f.input :country_of_origin
      f.input :alien_registration_number
      f.input :uscis_online_account_number
    end

    f.inputs 'Patient Contact' do
      f.input :street1
      f.input :street2
      f.input :city
      f.input :state
      f.input :zip
      f.input :email
      f.input :primary_phone
      f.input :alternate_phone
    end

    f.inputs 'Patient Interpretation' do
      f.input :interpreter_business_name
      f.input :interpreter_first_name
      f.input :interpreter_last_name
      f.input :interpreter_email
      f.input :interpreter_phone
    end

    f.inputs 'Additional Notes' do
      f.input :additional_notes
    end

    f.actions
  end

  show do
    panel 'Patient Demographics' do
      attributes_table_for patient do
        row :first_name
        row :last_name
        row :middle_name
        row :sex
        row :date_of_birth
        row :city_of_origin
        row :country_of_origin
        row :alien_registration_number
        row :uscis_online_account_number
      end
    end

    panel 'Patient Contact' do
      attributes_table_for patient do
        row :street1
        row :street2
        row :city
        row :state
        row :zip
        row :email
        row :primary_phone
        row :alternate_phone
      end
    end

    panel 'Patient Interpretation' do
      attributes_table_for patient do
        row :interpreter_business_name
        row :interpreter_first_name
        row :interpreter_last_name
        row :interpreter_email
        row :interpreter_phone
      end
    end

    panel 'Additional Notes' do
      attributes_table_for patient do
        row :additional_notes
      end
    end
  end

  controller do
    actions :all, :except => [:destroy]

    def edit
      customize_page_title(resource.id)
      super
    end

    def update
      customize_page_title(resource.id)
      super
    end

    def show
      customize_page_title(resource.id)
      super
    end

    private

    def customize_page_title patient_id
      patient = Patient.find(patient_id)
      patient_dob = patient.date_of_birth
      link = "<b><a href='/admin/patients/#{patient.id}'>#{patient.name}</a></b>"
      title = "Patient Details for...</br>#{link}</br>DOB: #{patient_dob}"
      @page_title = title.html_safe
    end
  end
end
