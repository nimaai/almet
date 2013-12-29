class ReservationsController < ApplicationController

  def index
    @reservations = if params[:past]
                      Reservation.past
                    elsif params[:future]
                      Reservation.future
                    else
                      Reservation.order(:arrival)
                    end
  end

  def new
    @reservation = Reservation.new
    @reservation.visitor = Visitor.new
  end

  def create
    @reservation = Reservation.new reservation_params

    if @reservation.save
      flash[:success] = "New reservation successfully created"
      redirect_to reservations_path(future: true) and return
    else
      flash[:error] = @reservation.errors.full_messages.join(", ")
      redirect_to :back and return
    end
  end

  private

    def reservation_params
      params.require(:reservation).permit(:arrival, :departure, :adults, :children, :bedclothes_service, visitor_attributes: [:firstname, :lastname, :street, :zip, :city, :country, :mobile, :phone, :email])
    end

end
