ActiveAdmin.register UnavailableBlock do
  menu false

  config.filters = false

  config.batch_actions = false

  permit_params :start_date, :end_date, :start_time, :end_time, :notes

  action_item :only => [:edit, :show] do
    confirmation_message = 'Are you sure you would like to remove this unavailable block?'
    link_to 'Remove Unavailable Block', admin_unavailable_block_path(unavailable_block), method: :delete, data: { confirm: confirmation_message }
  end

  index :download_links => false do
    column :start_date
    column :end_date
    column :start_time do |unavailable_block|
      unavailable_block.start_time
    end
    column :end_time do |unavailable_block|
      unavailable_block.end_time
    end
    column :notes
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    br
    f.inputs 'Unavailable Block Details' do
      f.input :start_date, :as => :datepicker
      f.input :start_time, :as => :string, :input_html => { :class => 'timepicker' }
      f.input :end_date, :as => :datepicker
      f.input :end_time, :as => :string, :input_html => { :class => 'timepicker' }
      f.input :notes
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(:back)
    end
  end

  member_action :cancel do
    return redirect_to_appointments
  end

  controller do
    def new
      start_date = params[:start_date]
      super
    end

    def create
      super do |format|
        start_date = resource.start_date
        end_date = resource.end_date
        if resource.valid?
          notice = 'Unavailable Block successfully created'
          parameters = { date: resource.start_date }
          return redirect_to_appointments(notice, parameters)
        end
      end
    end

    def update
      super do
        if resource.valid?
          notice = 'Unavailable Block successfully updated'
          parameters = { date: resource.start_date }
          return redirect_to_appointments(notice, parameters)
        end
      end
    end

    def destroy
      date = resource.start_date
      super do
        notice = 'Unavailable Block successfully destroyed'
        parameters = { date: date }
        return redirect_to_appointments(notice, parameters)
      end
    end

    def redirect_to_appointments notice, parameters
      return unless resource.valid?
      if parameters
        return redirect_to admin_appointments_path(parameters), notice: notice
      else
        return redirect_to admin_appointments_path, notice: notice
      end
    end
  end
end
