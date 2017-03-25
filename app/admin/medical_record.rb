ActiveAdmin.register MedicalRecord do

  menu false

  config.clear_action_items!

  action_item :only => [:index, :edit, :show] do
    params[:patient_id] ? patient = Patient.find(params[:patient_id]) : patient = medical_record.patient
    link_to 'Back to Patient', admin_patient_path(patient)
  end

  action_item :only => [:index] do
    params[:patient_id] ? patient = Patient.find(params[:patient_id]) : patient = medical_record.patient
    link_to 'New Medical Record', new_admin_medical_record_path(patient_id: patient.id)
  end

  action_item :only => [:edit, :show] do
    params[:patient_id] ? patient = Patient.find(params[:patient_id]) : patient = medical_record.patient
    link_to 'All Medical Records', admin_medical_records_path(patient_id: patient.id)
  end

  permit_params :kind, :scan, :patient_id, :date_of_service

  filter :kind, :as => :select, :collection => ['Physical', 'Lab Work']
  filter :date_of_service

  index :download_links => false do
    column :patient do |medical_record|
      patient = medical_record.patient
      patient.name
    end
    column :date_of_birth do |medical_record|
      patient = medical_record.patient
      patient.date_of_birth
    end
    column :date_of_service
    column :kind
    column :scan do |medical_record|
      image_tag(medical_record.scan.url(:thumb)) if medical_record.scan && !medical_record.scan.url.blank?
    end
    actions
  end

  form :multipart => true do |f|
    f.semantic_errors *f.object.errors.keys
    br
    f.inputs 'Medical Record Details' do
      params[:patient_id] ? patient = Patient.find(params[:patient_id]) : patient = medical_record.patient
      patient_collection = [["#{patient.id} - #{patient.last_name}, #{patient.first_name} #{patient.middle_name} (DOB: #{patient.date_of_birth})", patient.id ]]
      f.input :patient_id, label: 'Patient', :as => :select, :collection => patient_collection, :include_blank => false
      f.input :date_of_service, :as => :datepicker
      f.input :kind, :collection => ['Physical', 'Lab Work', 'Form', 'Other']
      f.input :scan, :label => 'Upload Scan', :hint => (image_tag(f.object.scan.url(:thumb)) if f.object.scan && !f.object.scan.url.blank?)
    end
    f.actions
  end

  show do
    panel 'Medical Record Details' do
      attributes_table_for medical_record do
        row :patient do
          patient = medical_record.patient
          link_to "#{patient.id} - #{patient.last_name}, #{patient.first_name} (DOB: #{patient.date_of_birth})", admin_patient_path(patient)
        end
        row :date_of_service
        row :kind
        row :scan do
          image_tag(medical_record.scan.url) if medical_record.scan && !medical_record.scan.url.blank?
        end
      end
    end
  end

  controller do
    actions :all, :except => [:destroy]

    before_action :find_record, :except => [:new, :create, :index]

    def scoped_collection
      super.where(patient_id: params[:patient_id])
    end

    def find_record
      # the scoped collection only wants to display medical records within the appropriate scope
      # let's explicitly instruct the action to find the medical record regardless of status
      @medical_record = MedicalRecord.find params[:id]
    end
  end
end
