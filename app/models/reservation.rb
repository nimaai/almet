class Reservation < ActiveRecord::Base

  belongs_to :visitor

  accepts_nested_attributes_for :visitor, reject_if: proc {|attributes| Visitor.exists? email: attributes[:email] }

  validates_presence_of :arrival, :departure, :guests

  validate do
    errors.add(:base, "Requested reservation is conflicting with some other reservation") if Reservation.all.any? {|r| conflicts? r }
  end

  def conflicts?(other)
    departure > other.arrival and arrival < other.departure
  end

end
