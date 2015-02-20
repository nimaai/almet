class ReservationsController < ApplicationController

  def index
    if params[:present]
      @present_reservation = \
        Reservation.where('arrival <= ? AND departure >= ?',
                          Date.today,
                          Date.tomorrow)
          .first
    end

    @reservations = if params[:past]
                      Reservation.past
                    elsif params[:future]
                      Reservation.future
                    else
                      Reservation.order(:arrival)
                    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    @reservation.visitor = Visitor.new
  end

  def create
    @reservation = Reservation.new reservation_params

    if @reservation.save
      flash[:success] = 'New reservation successfully created'
      redirect_to reservations_path(present: true, future: true)
    else
      flash.now[:error] = @reservation.errors.full_messages.join(', ')
      render :new and return
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.update_attributes(reservation_params)
      redirect_to action: :index, present: true, future: true
    else
      flash.now[:error] = @reservation.errors.full_messages.join(', ')
      render :edit and return
    end
  end

  def destroy
    Reservation.find(params[:id]).destroy
    flash[:success] = 'Reservation successfully deleted'
    redirect_to action: :index, present: true, future: true
  end

  private

  def reservation_params
    params.require(:reservation).permit \
      :arrival,
      :departure,
      :adults,
      :children,
      :bedclothes_service,
      visitor_attributes: [:firstname,
                           :lastname,
                           :street,
                           :zip,
                           :city,
                           :country,
                           :mobile,
                           :phone,
                           :email]
  end
end
