require 'test_helper.rb'

class ReservationTest < ActiveSupport::TestCase

  def setup
    @reservation_attrs = { arrival:            Date.tomorrow,
                           departure:          Date.tomorrow + 1,
                           adults:             2,
                           bedclothes_service: true }

    @visitor_attrs = { firstname:    'FirstnameX',
                       lastname:     'LastnameX',
                       street:       'StreetX 13',
                       zip:          'ZipX',
                       city:         'CityX',
                       country:      'CountryX',
                       mobile:       '0904123456',
                       phone:        '0411234567',
                       email:        'new_user@email.com' }
  end

  test 'past reservations' do
    assert_equal \
      Reservation.past.count,
      Reservation \
        .select { |r| r.departure <= Date.today }
        .count

    assert_equal \
      Reservation.past.first,
      Reservation \
        .select { |r| r.departure <= Date.today }
        .sort_by(&:departure)
        .last
  end

  test 'future reservations' do
    assert_equal \
      Reservation.future.count,
      Reservation \
        .select { |r| r.arrival >= Date.tomorrow }
        .count

    assert_equal \
      Reservation.future.first,
      Reservation \
        .select { |r| r.arrival >= Date.tomorrow }
        .sort_by(&:arrival)
        .first
  end

  test 'present reservation' do
    r = Reservation.present
    assert_equal \
      r,
      Reservation \
        .find { |res|
          res.arrival <= Date.today \
            and res.departure >= Date.tomorrow
        }

    assert r.present?
  end

  test 'default values for new reservation' do
    reservation = Reservation.new
    assert_equal reservation.arrival, Date.today
    assert_equal reservation.departure, Date.tomorrow
  end

  test 'no default values for reservation fetched from data base' do
    reservation = \
      Reservation \
        .where('arrival != ? AND departure != ?',
               Date.today,
               Date.tomorrow)
        .first

    assert_not_equal reservation.arrival, Date.today
    assert_not_equal reservation.departure, Date.tomorrow
  end

  test 'validation of arrival time in the past' do
    @reservation_attrs[:arrival] = Date.yesterday
    r = Reservation.new(@reservation_attrs)
    r.visitor = Visitor.new(@visitor_attrs)
    assert_not r.save
    assert_not r.persisted?
    assert_not r.visitor.persisted?
  end

  test 'validation of departure time being before arrival time' do
    @reservation_attrs[:departure] = Date.today
    r = Reservation.new(@reservation_attrs)
    r.visitor = Visitor.new(@visitor_attrs)
    assert_not r.save
    assert_not r.persisted?
    assert_not r.visitor.persisted?

    @reservation_attrs[:departure] = Date.tomorrow
    r = Reservation.new(@reservation_attrs)
    r.visitor = Visitor.new(@visitor_attrs)
    assert_not r.save
    assert_not r.persisted?
    assert_not r.visitor.persisted?
  end
end
