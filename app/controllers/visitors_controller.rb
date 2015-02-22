class VisitorsController < ApplicationController
  def index
    @visitors = Visitor.order(lastname: :asc)
  end

  def show
    @visitor = Visitor.find(params[:id])
  end
end
