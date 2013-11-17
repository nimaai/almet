class ReservationsController < ApplicationController
  def index
  end

  def new
    @reservation = Reservation.new params[:reservation]
  end
end
