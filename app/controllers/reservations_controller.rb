class ReservationsController < ApplicationController

  def index
    @reservations = Reservation.order(:arrival)
  end

  def create
    @reservation = Reservation.new reservation_params

    if @reservation.save
      flash[:notice] = "New reservation successfully created"
      redirect_to reservations_path
    else
      flash[:error] = @reservation.errors
      redirect_to :back
    end
  end

  private

    def reservation_params
      params.require(:reservation).permit(:arrival, :departure, :guests, visitor_attributes: [:firstname, :lastname, :street, :zip, :city, :country, :mobile, :phone, :email])
    end

end
