class ReservationsController < ApplicationController

  def index
    # TODO: refactor!
    if params[:past] == 'true'
      @reservations = Reservation.past
      @title = 'Past reservations'
    elsif params[:future] == 'true'
      @present_reservation = Reservation.present
      @reservations = Reservation.future
      @title = 'Future reservations'
    elsif params[:visitor_id]
      visitor = Visitor.find(params[:visitor_id])
      @reservations = Reservation.where(visitor_id: visitor.id)
      @title = "Reservations for #{visitor.fullname}"
    else
      redirect_to action: :index, future: 'true'
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    @reservation.visitor = Visitor.find_by_id(params[:visitor_id])
    @reservation.visitor ||= Visitor.new
  end

  def create
    @reservation = Reservation.new(reservation_params)

    begin
      ActiveRecord::Base.transaction do
        @reservation.visitor ||= \
          Visitor
            .create_with(visitor_params)
            .find_or_create_by!(email: visitor_params[:email])
        @reservation.save!
        flash[:success] = 'New reservation successfully created'
        redirect_to reservations_path(future: true)
      end
    rescue
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
      redirect_to action: :index, future: true
    else
      flash.now[:error] = @reservation.errors.full_messages.join(', ')
      render :edit and return
    end
  end

  def destroy
    Reservation.find(params[:id]).destroy
    flash[:success] = 'Reservation successfully deleted'
    redirect_to action: :index, future: 'true'
  end

  private

  def reservation_params
    params.require(:reservation).permit \
      :arrival,
      :departure,
      :adults,
      :children,
      :bedclothes_service,
      :visitor_id
  end

  def visitor_params
    params.require(:visitor).permit \
      :firstname,
      :lastname,
      :street,
      :zip,
      :city,
      :country,
      :mobile,
      :phone,
      :email
  end
end
