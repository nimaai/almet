class ReservationsController < ApplicationController

  def create
    if @reservation = Reservation.create(params[:reservation])
      flash[:notice] = "New reservation successfully created"
      redirect_to root_path
    else
      flash[:error] = @reservation.errors
      redirect_to :back, flash[:error]
    end
  end

end
