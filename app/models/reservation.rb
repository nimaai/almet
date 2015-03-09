class Reservation < ActiveRecord::Base

  belongs_to :visitor

  validates_presence_of :arrival, :departure, :adults
  validates_inclusion_of :bedclothes_service, in: [true, false]

  validate do
    # TODO: check only future reservations?
    if cr = Reservation.find { |r| r != self and conflicts? r }
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

  after_initialize do
    if new_record?
      self.arrival ||= Date.today
      self.departure ||= Date.tomorrow
    end
  end

  def conflicts?(other)
    departure > other.arrival and arrival < other.departure
  end

  def self.present
    find_by('arrival <= ? AND departure >= ?',
            Date.today,
            Date.tomorrow)
  end

  def present?
    self == Reservation.present
  end
end
