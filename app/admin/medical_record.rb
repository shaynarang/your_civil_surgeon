ActiveAdmin.register MedicalRecord do

  permit_params :kind, :scan, :patient_id, :date_of_service

  filter :patient,
    collection:
      Patient.joins(:medical_records)
        .order(:last_name)
        .map{|p| ["#{p.id} - #{p.last_name}, #{p.first_name} #{p.middle_name} (#{p.date_of_birth})", p.id ]}
  filter :kind, :as => :select, :collection => ['Physical', 'Lab Work']
  filter :date_of_service

  index do
    column :patient do |medical_record|
      p = medical_record.patient
      "#{p.id} - #{p.last_name}, #{p.first_name} (#{p.date_of_birth})"
    end
    column :date_of_service
    column :kind
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Medical Record Details' do
      patient_collection = Patient.order(:last_name).map{|p| ["#{p.id} - #{p.last_name}, #{p.first_name} #{p.middle_name} (#{p.date_of_birth})", p.id ]}
      f.input :patient_id, label: 'Patient', :as => :select, :collection => patient_collection
      f.input :date_of_service
      f.input :kind, :collection => ['Physical', 'Lab Work']
      f.input :scan
    end
    f.actions
  end

  show do
    panel 'Medical Record Details' do
      attributes_table_for medical_record do
        row :patient do
          p = medical_record.patient
          link_to "#{p.id} - #{p.last_name}, #{p.first_name} (#{p.date_of_birth})", admin_patient_path(p)
        end
        row :date_of_service
        row :kind
        row :scan
      end
    end
  end
end
