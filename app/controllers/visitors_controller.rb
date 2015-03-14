class VisitorsController < ApplicationController
  def index
    @visitors = Visitor.order(lastname: :asc)
  end

  def show
    @visitor = Visitor.find(params[:id])
  end

  def edit
    @visitor = Visitor.find(params[:id])
  end

  def update
    @visitor = Visitor.find(params[:id])

    if @visitor.update_attributes(visitor_params)
      flash[:success] = 'Visitor updated successfully'
      redirect_to action: :index
    else
      flash.now[:error] = @visitor.errors.full_messages.join(', ')
      render :edit and return
    end
  end

  private

  def visitor_params
    params.permit \
      :firstname,
      :lastname,
      :street,
      :zip,
      :city,
      :country,
      :mobile,
      :phone
  end
end
