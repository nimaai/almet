class Reservation < ActiveRecord::Base

  belongs_to :visitor

  accepts_nested_attributes_for \
    :visitor,
    reject_if: \
      (proc do |attributes|
        Visitor.exists? email: attributes[:email]
      end)

  validates_presence_of :arrival, :departure, :adults, :bedclothes_service

  validate do
    if cr = Reservation.find { |r| conflicts? r }
      errors.add \
        :base,
        %(Requested reservation conflicts with another reservation \
          (#{I18n.l cr.arrival} - #{I18n.l cr.departure}))
    end

    errors.add(:base, 'Arrival date cannot be in the past') if arrival.past?

    if arrival >= departure
      errors.add(:base, 'Arrival date must be before departure date')
    end
  end

  scope :past, -> { where('departure <= ?', Date.today).order('departure DESC') }
  scope :future, -> { where('arrival >= ?', Date.tomorrow).order('arrival ASC') }

  scope :present, lambda {
    where('arrival <= ? AND departure >= ?',
          Date.today,
          Date.tomorrow)
      .first
  }

  scope :present_and_future,
        -> { where('departure >= ?', Date.tomorrow).order('departure ASC') }

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

  def reserved_dates(from_today: false, exclude_arrival: false)
    start_date = if from_today
                   Date.today
                 elsif exclude_arrival
                   arrival + 1
                 else
                   arrival
                 end
    (start_date..departure - 1).to_a
  end

  def self.reserved_dates_from_today(exclude_arrival_dates = false)
    Reservation
      .present_and_future
      .flat_map do |r|
        if r.present?
          r.reserved_dates(from_today: true)
        else
          r.reserved_dates(exclude_arrival: exclude_arrival_dates)
        end
      end
  end

end
