class Visitor < ActiveRecord::Base
  has_many :reservations

  validates_presence_of :firstname, :lastname, :street, :zip, :city, :country, :mobile, :email
  validates_presence_of :phone, unless: :mobile?
  validates_uniqueness_of :email
end
