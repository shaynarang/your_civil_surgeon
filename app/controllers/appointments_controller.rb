class AppointmentsController < ApplicationController
  def index
    # this is a json endpoint
    return redirect_to '/' unless current_admin

    if params[:date]
      @appointments = Appointment.on_the_books.where(date: params[:date])
    else
      @appointments = Appointment.on_the_books
    end

    render :index
  end
end
