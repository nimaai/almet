class Reservation < ActiveRecord::Base

  belongs_to :visitor

  accepts_nested_attributes_for :visitor, reject_if: proc {|attributes| Visitor.exists? email: attributes[:email] }

  validates_presence_of :arrival, :departure, :adults, :bedclothes_service

  validate do
    errors.add(:base, "Requested reservation conflicts with some other reservation") if Reservation.all.any? {|r| conflicts? r }
  end

  scope :past, -> { where("departure <= ?", Date.today).order("departure DESC") }
  scope :future, -> { where("arrival >= ?", Date.tomorrow).order("arrival ASC") }
  scope :present, -> { where("arrival <= ? AND departure >= ?", Date.today, Date.tomorrow).first }

  after_initialize do
    if new_record?
      self.arrival ||= Date.today
      self.departure ||= Date.tomorrow
    end
  end

  def conflicts?(other)
    departure > other.arrival and arrival < other.departure
  end

  def present?
    self == Reservation.present
  end

end
