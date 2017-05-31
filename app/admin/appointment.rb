ActiveAdmin.register Appointment do
  menu priority: 2

  permit_params :date, :time, :patient_id, :notes, :status

  config.filters = false

  config.clear_action_items!

  config.batch_actions = false

  config.paginate = false

  action_item :only => [:edit, :show] do
    unless appointment.status == 'Cancelled'
      confirmation_message = 'Are you sure you would like to cancel this appointment?'
      link_to 'Cancel Appointment', cancel_admin_appointment_path, data: { confirm: confirmation_message }
    end
  end

  action_item :only => [:index] do
    if params[:patient_id]
      link_to 'Exit Patient', admin_appointments_path
    else
      link_to 'Patients', admin_patients_path
    end
  end

  action_item :only => [:index] do
    unless params[:patient_id]
      link_to 'Block Time', admin_appointments_path(block_time: true)
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
      f.input :status, :as => :select, :collection => ['Scheduled', 'Confirmed '], :include_blank => false
      f.input :patient_agnostic, :as => :hidden, :input_html => { :value => controller.instance_variable_get(:@patient_agnostic), :width => '20%' }
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
        link = "<b><a href='/admin/patients/#{patient.id}'>#{patient.name}</a></b>"
        text = "<span class='blink'>Scheduling Appointment for...</span></br>#{link}</br>DOB: #{patient_dob} (#{patient.age} years old)"
        @page_title = text.html_safe
      elsif params[:block_time]
        text = "<span class='blink'>Blocking Time</span>"
        @page_title = text.html_safe
      end
    end

    def new
      date = params[:date]
      patient_id = params[:patient_id]
      customize_page_title(patient_id)
      super
    end

    def create
      super do |format|
        date = resource.date
        patient_id = resource.patient_id
        customize_page_title(patient_id)
        if resource.valid?
          parameters = { patient_id: patient_id, date: date }
          notice = 'Appointment successfully created'
          return redirect_to_index(notice, parameters)
        end
      end
    end

    def edit
      super do
        @patient_agnostic = params[:patient_agnostic]
        date = resource.date
        patient_id = resource.patient_id
        customize_page_title(patient_id)
      end
    end

    def update
      super do
        date = resource.date
        patient_id = resource.patient_id
        customize_page_title(patient_id)
        patient_agnostic = params['appointment']['patient_agnostic']
        @patient_agnostic = true if patient_agnostic.present?
        if resource.valid?
          parameters =
            @patient_agnostic ? { date: date } : { patient_id: patient_id, date: date }
          notice = 'Appointment successfully updated'
          return redirect_to_index(notice, parameters)
        end
      end
    end

    private

    def customize_page_title patient_id
      patient = Patient.find(patient_id)
      patient_dob = patient.date_of_birth
      link = "<b><a href='/admin/patients/#{patient.id}'>#{patient.name}</a></b>"
      title = "Appointment Details for...</br>#{link}</br>DOB: #{patient_dob} (#{patient.age} years old)"
      @page_title = title.html_safe
    end

    def redirect_to_index notice, parameters
      if resource.valid?
        return redirect_to collection_url(parameters), notice: notice
      end
    end
  end
end
