class AppointmentsController < ApplicationController
  def index
    # this is a json endpoint
    return redirect_to '/' unless current_admin

    if params[:date]
      unavailable_blocks = UnavailableBlock.contains_date(params[:date])
      appointments = Appointment.on_the_books.includes(:patient).where(date: params[:date])
      @appointments = unavailable_blocks + appointments
    else
      @appointments = Appointment.on_the_books.includes(:patient) + UnavailableBlock.all
    end

    render :index
  end

  def update
    appointment = Appointment.find(params[:id])
    date = params[:date]

    appointment.update_attributes(date: date)

    head :ok
  end
end
