class AppointmentsController < ApplicationController
  def index
    return redirect_to '/' unless current_admin

    if params[:date]
      @appointments = Appointment.where(date: params[:date])
    else
      @appointments = Appointment.all
    end

    render :index
  end
end
