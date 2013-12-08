require 'test_helper.rb'

class ReservationTest < ActiveSupport::TestCase

  def setup
    @reservation_attrs = { arrival:            Date.today.to_s,
                           departure:          Date.tomorrow.to_s,
                           guests:             2 }

    @visitor_attrs = { firstname:    "FirstnameX",
                       lastname:     "LastnameX",
                       street:       "StreetX 13",
                       zip:          "ZipX",
                       city:         "CityX",
                       country:      "CountryX",
                       mobile:       "0904123456",
                       phone:        "0411234567",
                       email:        "new_user@email.com" }
  end

  test "creation of a new reservation and a new visitor" do

    r = Reservation.new @reservation_attrs.merge(visitor_attributes: @visitor_attrs)
    assert r.save
    assert r.persisted?
    assert r.visitor

  end

  test "creation of only a new reservation" do

    @visitor_attrs[:email] = "user1@email.com"

    r = Reservation.new @reservation_attrs.merge(visitor_attributes: @visitor_attrs)
    assert r.save
    assert r.persisted?
    assert_nil r.visitor

  end

  #test "validation of conflicting date range" do

    #r = Reservation.new arrival: Date.today + 4.days, departure: Date.today + 6.days, guests: 1, visitor_attributes: @visitor_attrs

    #assert_not r.save
    #assert_not r.persisted?

  #end

end
