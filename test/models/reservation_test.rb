require 'test_helper.rb'

class ReservationTest < ActiveSupport::TestCase

  test "creation of a new reservation and a new visitor" do

    visitor_attrs = { firstname:    "FirstnameX",
                      lastname:     "LastnameX",
                      street:       "StreetX 13",
                      zip:          "ZipX",
                      city:         "CityX",
                      country:      "CountryX",
                      mobile:       "0904123456",
                      phone:        "0411234567",
                      email:        "email@email.com" }

    reservation_attrs = { arrival:            Date.today.to_s,
                          departure:          Date.tomorrow.to_s,
                          guests:             2,
                          visitor_attributes: visitor_attrs }

    r = Reservation.new reservation_attrs
    assert r.save
    assert r.persisted?
    assert r.visitor

  end

end
