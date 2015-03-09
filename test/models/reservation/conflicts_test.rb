require 'test_helper.rb'

class ConflictsTest < ActiveSupport::TestCase

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

  test 'validation of conflicting date range with one reservation' do

    # -.-*-.-.-*-.-
    # -*-.-*-.-.-.-
    r = \
      Reservation.new \
        arrival: Date.today + 4.days,
        departure: Date.today + 6.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    cr = Reservation.find { |cr| r.conflicts? cr }
    assert_not r.save
    assert_match \
      /#{I18n.l cr.arrival} - #{I18n.l cr.departure}/,
      r.errors.full_messages.first

    # -.-*-.-.-*-.-
    # -.-*-*-.-.-.-
    r = \
      Reservation.new \
        arrival: Date.today + 5.days,
        departure: Date.today + 6.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    # -.-*-.-.-*-.-
    # -.-.-*-*-.-.-
    r = \
      Reservation.new \
        arrival: Date.today + 6.days,
        departure: Date.today + 7.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    # -.-*-.-.-*-.-
    # -.-.-*-.-*-.-
    r = \
      Reservation.new \
        arrival: Date.today + 6.days,
        departure: Date.today + 8.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    # -.-*-.-.-*-.-
    # -.-.-*-.-.-*-
    r = \
      Reservation.new \
        arrival: Date.today + 6.days,
        departure: Date.today + 9.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    # -.-*-.-.-*-.-
    # -*-.-.-.-.-*-
    r = \
      Reservation.new \
        arrival: Date.today + 4.days,
        departure: Date.today + 9.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    assert_not r.persisted?
    assert_not r.visitor.persisted?

  end

  test 'validation of non conflicting date range 1' do

    # -.-*-.-.-*-.-
    # -*-*-.-.-.-.-
    r = \
      Reservation.new \
        arrival: Date.today + 4.days,
        departure: Date.today + 5.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert r.save
    assert r.persisted?
    assert r.visitor.persisted?

  end

  test 'validation of non conflicting date range 2' do

    # -.-*-.-.-*-.-
    # -.-.-.-.-*-*-
    r = \
      Reservation.new \
        arrival: Date.today + 8.days,
        departure: Date.today + 9.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert r.save
    assert r.persisted?
    assert r.visitor.persisted?

  end

  test 'validation of conflicting date range with two reservation' do

    # -.-*-.-.-*-.-.-*-.-.-*-.-
    # -.-.-.-*-.-.-.-.-*-.-.-.-
    r = \
      Reservation.new \
        arrival: Date.today + 7.days,
        departure: Date.today + 12.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    # -.-*-.-.-*-.-.-*-.-.-*-.-
    # -*-.-.-.-.-.-.-.-*-.-.-.-
    r = \
      Reservation.new \
        arrival: Date.today + 7.days,
        departure: Date.today + 12.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    # -.-*-.-.-*-.-.-*-.-.-*-.-
    # -*-.-.-.-.-.-.-.-.-.-.-*-
    r = \
      Reservation.new \
        arrival: Date.today + 7.days,
        departure: Date.today + 12.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    # -.-*-*-*-.-
    # -.-.-*-*-.-
    r = \
      Reservation.new \
        arrival: Date.today + 20.days,
        departure: Date.today + 21.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert_not r.save

    assert_not r.persisted?
    assert_not r.visitor.persisted?

  end

  test 'validation of non conflicting date range with two reservations' do

    # -.-*-*-*-*-.-
    # -.-.-*-*-.-.-
    r = \
      Reservation.new \
        arrival: Date.today + 18.days,
        departure: Date.today + 19.days,
        adults: 1,
        bedclothes_service: true
    r.visitor = Visitor.new(@visitor_attrs)

    assert r.save
    assert r.persisted?
    assert r.visitor.persisted?

  end

  test 'no conflict with self' do
    r = Reservation.future.sample

    assert_equal r.update_attributes(arrival: r.arrival,
                                     departure: r.departure),
                 true

    assert r.persisted?
  end

end
