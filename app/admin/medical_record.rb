ActiveAdmin.register MedicalRecord do

  menu false

  permit_params :kind, :scan, :patient_id, :date_of_service

  filter :patient,
    collection:
      Patient.joins(:medical_records)
        .order(:last_name)
        .map{|p| ["#{p.id} - #{p.last_name}, #{p.first_name} #{p.middle_name} (DOB: #{p.date_of_birth})", p.id ]}
  filter :kind, :as => :select, :collection => ['Physical', 'Lab Work']
  filter :date_of_service

  index :download_links => false do
    column :patient do |medical_record|
      p = medical_record.patient
      "#{p.id} - #{p.last_name}, #{p.first_name} (DOB: #{p.date_of_birth})"
    end
    column :date_of_service
    column :kind
    column :scan do |medical_record|
      image = image_tag(medical_record.scan.url(:thumb)) if medical_record.scan && !medical_record.scan.url.blank?
      link_to image, admin_medical_record_path(medical_record)
    end
    actions
  end

  form :multipart => true do |f|
    f.semantic_errors *f.object.errors.keys
    br
    f.inputs 'Medical Record Details' do
      patient_collection = Patient.order(:last_name).map{|p| ["#{p.id} - #{p.last_name}, #{p.first_name} #{p.middle_name} (DOB: #{p.date_of_birth})", p.id ]}
      f.input :patient_id, label: 'Patient', :as => :select, :collection => patient_collection
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
          p = medical_record.patient
          link_to "#{p.id} - #{p.last_name}, #{p.first_name} (DOB: #{p.date_of_birth})", admin_patient_path(p)
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
  end
end
