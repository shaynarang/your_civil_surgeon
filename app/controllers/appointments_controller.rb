class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
    render :index
  end
end
