class Reservation < ActiveRecord::Base

  belongs_to :visitor

  accepts_nested_attributes_for \
    :visitor,
    reject_if: \
      Proc.new { |attributes|
        Visitor.exists? email: attributes[:email]
      }

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
