class VisitorsController < ApplicationController
  def index
    @visitors = Visitor.order(lastname: :asc)
  end
end
