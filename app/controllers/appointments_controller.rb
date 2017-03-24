class AppointmentsController < ApplicationController
  def index
    return redirect_to '/' unless current_admin

    if params[:date]
      @appointments = Appointment.on_the_books.where(date: params[:date])
    else
      @appointments = Appointment.on_the_books
    end

    render :index
  end

  def cancel
    appointment = Appointment.find(params[:id])
    appointment.update_attributes(status: 'Cancelled')
    flash[:notice] = 'Appointment has been cancelled'
    redirect_to admin_appointments_path
  end
end
