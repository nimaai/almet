class Visitor < ActiveRecord::Base
  has_many :reservations

  validates_presence_of :firstname, :lastname, :street, :zip, :city, :country, :email
  validates_presence_of :phone, unless: :mobile?
  validates_presence_of :mobile, unless: :phone?
  validates_uniqueness_of :email

  def fullname
    "#{firstname} #{lastname}"
  end
end
