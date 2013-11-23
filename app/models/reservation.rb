class Reservation < ActiveRecord::Base
  belongs_to :visitor

  accepts_nested_attributes_for :visitor, reject_if: proc {|attributes| Visitor.exists? attributes[:firstname], attributes[:lastname], attributes[:email] }

  validates_presence_of :arrival, :departure, :guests
end
