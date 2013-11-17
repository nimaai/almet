class Visitor < ActiveRecord::Base
  has_many :reservations

  validates_presence_of :firstname, :lastname, :street, :zip, :city, :phone, :mobile, :email
end
