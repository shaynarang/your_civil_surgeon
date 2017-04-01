ActiveAdmin.register Appointment do
  permit_params :date, :time, :patient_id, :notes, :status

  config.filters = false

  config.clear_action_items!

  action_item :only => [:edit, :show] do
    unless appointment.status == 'Cancelled'
      confirmation_message = 'Are you sure you would like to cancel this appointment?'
      link_to 'Cancel Appointment', cancel_admin_appointment_path, data: { confirm: confirmation_message }
    end
  end

  action_item :only => [:index] do
    if params[:patient_id]
      link_to 'Exit Patient', admin_appointments_path
    end
  end

  index :download_links => false do
    div id: 'calendar'
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    br
    f.inputs 'Appointment Details' do
      f.input :patient_id, label: 'Patient', :as => :hidden, :input_html => { :readonly => true }
      f.input :date, :as => :datepicker
      f.input :time, :as => :string, :input_html => { :class => 'timepicker' }
      f.input :notes
      f.input :status, :as => :select, :collection => ['Cancelled', 'Confirmed', 'Unconfirmed'], :include_blank => true
      f.input :patient_agnostic, :as => :hidden, :input_html => { :value => params[:patient_agnostic]}
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

  member_action :cancel do
    resource.update_attributes(status: 'Cancelled')
    notice = 'Appointment has been cancelled'
    parameters = { date: resource.date }
    return redirect_to_index(notice, parameters)
  end

  controller do

    def index
      if params[:patient_id]
        patient = Patient.find(params[:patient_id])
        patient_name = "#{patient.first_name} #{patient.last_name}"
        patient_dob = patient.date_of_birth
        link = "<b><a href='/admin/patients/#{patient.id}'>#{patient_name}</a></b>"
        text = "Scheduling Appointment for #{link} (#{patient_dob})"
        @page_title = text.html_safe
      end
    end

    def new
      use_patient_page_title(params[:patient_id])
      super
    end

    def create
      super do |format|
        if resource.valid?
          parameters = { patient_id: resource.patient_id, date: resource.date }
          notice = 'Appointment successfully created'
          return redirect_to_index(notice, parameters)
        end
      end
    end

    def edit
      use_patient_page_title(resource.patient_id)
      super
    end

    def update
      super do |format|
        if resource.valid?
          if params['appointment']['patient_agnostic'].present?
            parameters = { date: resource.date }
          else
            parameters = { patient_id: resource.patient_id, date: resource.date }
          end
          notice = 'Appointment successfully updated'
          return redirect_to_index(notice, parameters)
        elsif params['appointment']['patient_agnostic'].present?
          params['appointment']['patient_agnostic'] = 'true'
        end
      end
    end

    private

    def use_patient_page_title patient_id
      patient = Patient.find(patient_id)
      patient_name = "#{patient.first_name} #{patient.last_name}"
      patient_dob = patient.date_of_birth
      link = "<b><a href='/admin/patients/#{patient.id}'>#{patient_name}</a></b>"
      title = "Appointment Details for #{link} (#{patient_dob})"
      @page_title = title.html_safe
    end

    def redirect_to_index notice, parameters
      if resource.valid?
        return redirect_to collection_url(parameters), notice: notice
      end
    end
  end
end
