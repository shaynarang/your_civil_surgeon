ActiveAdmin.register MedicalRecord do

  menu false

  config.clear_action_items!

  config.sort_order = 'date_of_service_desc'

  action_item :only => [:index] do
    params[:patient_id] ? patient = Patient.find(params[:patient_id]) : patient = medical_record.patient
    link_to 'New Medical Record', new_admin_medical_record_path(patient_id: patient.id)
  end

  action_item :only => [:show] do
    link_to 'Edit', edit_admin_medical_record_path(resource)
  end

  action_item :only => [:edit, :show] do
    if medical_record.scan && !medical_record.scan.url.blank?
      link_to 'Download', download_medical_record_path(resource)
    end
  end

  action_item :only => [:edit, :show] do
    params[:patient_id] ? patient = Patient.find(params[:patient_id]) : patient = medical_record.patient
    link_to 'Back to Medical Records', admin_medical_records_path(patient_id: patient.id)
  end

  action_item :only => [:index, :edit] do
    params[:patient_id] ? patient = Patient.find(params[:patient_id]) : patient = medical_record.patient
    link_to 'Back to Patient', admin_patient_path(patient)
  end

  permit_params :kind, :scan, :patient_id, :date_of_service

  filter :kind, :as => :select, :collection => ['Physical', 'Lab Work']
  filter :date_of_service

  index :download_links => false do
    column :date_of_service
    column :kind
    column :scan do |medical_record|
      image_tag(medical_record.scan.url(:thumb)) if medical_record.scan && !medical_record.scan.url.blank?
    end
    actions name: 'Edit'
  end

  form :multipart => true do |f|
    f.semantic_errors *f.object.errors.keys
    br
    f.inputs 'Medical Record Details' do
      f.input :patient_id, label: 'Patient', :as => :hidden, :include_blank => false
      f.input :date_of_service, :as => :datepicker
      f.input :kind, :collection => ['Physical', 'Lab', 'X-Ray', 'Immunization', 'Other']
      f.input :scan, :label => 'Upload Scan', :hint => (image_tag(f.object.scan.url(:thumb)) if f.object.scan && !f.object.scan.url.blank?)
      f.input :_destroy_scan, as: :boolean, required: :false, label: 'Remove scan'
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(:back)
    end
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
          scan = medical_record.scan
          if scan && !scan.url.blank?
            full_version = scan.content_type.include?('/pdf') ? scan.url(:full) : scan.url
            link_to scan.url, :target => '_blank' do
              image_tag(full_version)
            end
          end
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

    def index
      super do
        if params[:patient_id]
          patient = Patient.find(params[:patient_id])
          patient_name = "#{patient.first_name} #{patient.last_name}"
          patient_dob = patient.date_of_birth
          link = "<b><a href='/admin/patients/#{patient.id}'>#{patient.name}</a></b>"
          text = "Medical Records for...</br>#{link}</br>DOB: #{patient_dob} (#{patient.age} years old)"
          @page_title = text.html_safe
        end
      end
    end

    def new
      customize_page_title(params[:patient_id])
      super
    end

    def create
      # remove scan if destroy checkbox is checked
      resource['scan'] = nil if params[:medical_record][:_destroy_scan] == '1'
      super
    end

    def edit
      customize_page_title(resource.patient_id)
      super
    end

    def update
      # remove scan if destroy checkbox is checked
      resource['scan'] = nil if params[:medical_record][:_destroy_scan] == '1'
      customize_page_title(resource.patient_id)
      super
    end

    def show
      customize_page_title(resource.patient_id)
      super
    end

    private

    def find_record
      # the scoped collection only wants to display medical records within the appropriate scope
      # let's explicitly instruct the action to find the medical record regardless of status
      @medical_record = MedicalRecord.find params[:id]
    end

    def customize_page_title patient_id
      patient = Patient.find(patient_id)
      patient_dob = patient.date_of_birth
      link = "<b><a href='/admin/patients/#{patient.id}'>#{patient.name}</a></b>"
      title = "Medical Record Details for...</br>#{link}</br>DOB: #{patient_dob} (#{patient.age} years old)"
      @page_title = title.html_safe
    end
  end
end
