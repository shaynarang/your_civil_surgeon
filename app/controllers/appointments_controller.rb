class AppointmentsController < ApplicationController
  def index
    return redirect_to '/' unless current_admin
    @appointments = Appointment.all
    render :index
  end
end
