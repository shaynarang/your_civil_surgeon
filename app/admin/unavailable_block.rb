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
      f.input :start_date, :as => :datepicker, :required => true
      f.input :start_time, :as => :string, :required => true, :input_html => { :class => 'timepicker' }
      f.input :end_date, :as => :datepicker, :required => true
      f.input :end_time, :as => :string, :required => true, :input_html => { :class => 'timepicker' }
      f.input :notes, :required => true
    end
    f.actions do
      f.action(:submit)
      f.action(:cancel, :label => 'Back', :url => admin_appointments_path(block_time: true, date: params[:start_date]) )
    end
  end

  member_action :cancel do
    return redirect_to_appointments
  end

  controller do
    def create
      block = permitted_params[:unavailable_block].to_h

      # reject empty block params
      block.reject!{|_, v| v.blank?}

      alert =
        if block.length < 5
          # require all block params
          'Please complete all fields'
        elsif block[:end_date] < block[:start_date]
          'End date must be after start date'
        elsif (block[:end_date] == block[:start_date]) && (block[:end_time].to_time < block[:start_time].to_time)
          'End time must be after start time'
        end

      return redirect_back_with_alert(alert) if alert

      days = (block[:start_date]..block[:end_date]).to_a

      series_identifier = UnavailableBlock.generate_series_identifer

      if days.count > 1
        create_multi_day_block(series_identifier, days, block)
      else
        create_single_day_block(series_identifier, days, block)
      end

      notice = 'Unavailable Block successfully created'
      parameters = { date: block[:start_date] }
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

    private

    def redirect_back_with_alert alert
      redirect_back(
        fallback_location: admin_appointments_path,
        alert: alert
      )
    end

    def redirect_to_appointments notice, parameters
      if parameters
        return redirect_to admin_appointments_path(parameters), notice: notice
      else
        return redirect_to admin_appointments_path, notice: notice
      end
    end

    def create_multi_day_block series_identifier, days, block
      days.each_with_index do |day, index|
        # first day in the multi-day block
        if index == 0
          start_time = block[:start_time]
          end_time = '04:15PM'
        # last day in the multi-day block
        elsif index == (days.count - 1)
          start_time = '09:00AM'
          end_time = block[:end_time]
        # middle day in the multi-day block
        else
          start_time = '09:00AM'
          end_time = '04:15PM'
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

    def create_single_day_block series_identifier, days, block
      day = days[0]
      start_time = block[:start_time]
      end_time = block[:end_time]
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
end
