ActiveAdmin.register Appointment do
  permit_params :date, :time, :patient_id, :notes, :status

  index do
    selectable_column
    column :date
    column :time do |appointment|
      appointment.friendly_time
    end
    column :patient do |appointment|
      p = appointment.patient
      link_to "NAME: #{p.last_name}, #{p.first_name} #{p.middle_name}<br>DOB: #{p.date_of_birth}".html_safe, admin_patient_path(p)
    end
    column :notes
    column :status
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Appointment Details' do
      patient_collection = Patient.order(:last_name).map{|p| ["#{p.id} - #{p.last_name}, #{p.first_name} #{p.middle_name} (DOB: #{p.date_of_birth})", p.id ]}
      f.input :patient_id, label: 'Patient', :as => :select, :collection => patient_collection
      f.input :date, :as => :datepicker
      f.input :time, :as => :string, :input_html => { :class => 'timepicker' }
      f.input :notes
    end
    f.actions
  end

  show do
    panel 'Appointment Details' do
      attributes_table_for appointment do
        row :patient do
          p = appointment.patient
          link_to "#{p.id} - #{p.last_name}, #{p.first_name} (DOB: #{p.date_of_birth})", admin_patient_path(p)
        end
        row :date
        row :time
        row :notes
      end
    end
  end
end
