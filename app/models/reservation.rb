class Reservation < ActiveRecord::Base

  belongs_to :visitor

  accepts_nested_attributes_for :visitor, reject_if: proc {|attributes| Visitor.exists? email: attributes[:email] }

  validates_presence_of :arrival, :departure, :guests

  validate do
    #not Reservation.all.any? {|r| (r.arrival..r.departure).overlaps? self }
  end

end
