class Reservation < ActiveRecord::Base

  belongs_to :visitor

  accepts_nested_attributes_for :visitor, reject_if: proc {|attributes| Visitor.exists? email: attributes[:email] }

  validates_presence_of :arrival, :departure, :adults, :bedclothes_service

  validate do
    if cr = Reservation.find {|r| conflicts? r }
      errors.add(:base, "Requested reservation conflicts with another reservation (#{I18n.l cr.arrival} - #{I18n.l cr.departure})")
    end

    errors.add(:base, "Arrival date cannot be in the past") if arrival.past?
    errors.add(:base, "Arrival date must be before departure date") if arrival >= departure
  end

  scope :past, -> { where("departure <= ?", Date.today).order("departure DESC") }
  scope :future, -> { where("arrival >= ?", Date.tomorrow).order("arrival ASC") }
  scope :present, -> { where("arrival <= ? AND departure >= ?", Date.today, Date.tomorrow).first }
  scope :present_and_future, -> { where("departure >= ?", Date.tomorrow).order("departure ASC") }

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
    arrival <= Date.today and departure >= Date.tomorrow
  end

  def reserved_dates(from_today = false)
    start_date = from_today ? Date.today : arrival
    (start_date..departure - 1).to_a
  end

  def Reservation.reserved_dates_from_today
    Reservation.present_and_future.flat_map {|r| r.present? ? r.reserved_dates(:from_today) : r.reserved_dates }
  end

end
