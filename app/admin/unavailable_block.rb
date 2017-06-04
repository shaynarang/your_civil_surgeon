ActiveAdmin.register UnavailableBlock do
  menu false

  config.filters = false

  config.batch_actions = false

  permit_params :start_date, :end_date, :start_time, :end_time, :notes

  action_item :only => [:edit, :show] do
    confirmation_message = 'Are you sure you would like to remove this unavailable block?'
    link_to 'Remove Unavailable Block', admin_unavailable_block_path(unavailable_block), method: :delete, data: { confirm: confirmation_message }
  end

  action_item :only => [:edit, :show] do
    confirmation_message = 'Are you sure you would like to remove this series of unavailable blocks?'
    link_to 'Remove All Unavailable Blocks in Series', admin_unavailable_block_path(unavailable_block, remove_series: true), method: :delete, data: { confirm: confirmation_message }
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
      params[:action] == 'edit' || params[:action] == 'update' ? disabled = true : disabled = false
      f.input :end_date, :as => :datepicker, :input_html => { :disabled => disabled }
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
      block = params[:unavailable_block]
      start_date = block[:start_date]
      end_date = block[:end_date]
      days = (start_date..end_date).to_a

      if days.count > 1
        series_identifier = UnavailableBlock.generate_series_identifer
        days.each_with_index do |day, index|
          if index == 0
            start_time = block[:start_time]
            end_time = '04:30PM'
          elsif index == (days.count - 1)
            start_time = '09:00AM'
            end_time = block[:end_time]
          else
            start_time = '09:00AM'
            end_time = '04:30PM'
          end
          UnavailableBlock.create(
            start_date: day,
            end_date: day,
            start_time: start_time,
            end_time: end_time,
            notes: block[:notes],
            series_identifier: series_identifier
          )
        end
      end

      notice = 'Unavailable Block successfully created'
      parameters = { date: start_date }
      return redirect_to_appointments(notice, parameters)
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
      start_date = resource.start_date

      if params[:remove_series]
        UnavailableBlock.where(series_identifier: resource.series_identifier).destroy_all
      else
        resource.destroy
      end

      notice = 'Unavailable Block(s) successfully destroyed'
      parameters = { date: start_date }
      return redirect_to_appointments(notice, parameters)
    end

    def redirect_to_appointments notice, parameters
      if parameters
        return redirect_to admin_appointments_path(parameters), notice: notice
      else
        return redirect_to admin_appointments_path, notice: notice
      end
    end
  end
end
