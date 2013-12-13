class ReservationsControllerTest < ActionController::TestCase

  def setup
    @reservation_attrs = { arrival:            Date.today.to_s,
                           departure:          Date.tomorrow.to_s,
                           guests:             2 }

    @visitor_attrs = { firstname:    "FirstnameX",
                       lastname:     "LastnameX",
                       street:       "StreetX 13",
                       zip:          "ZipX", city:         "CityX",
                       country:      "CountryX",
                       mobile:       "0904123456",
                       phone:        "0411234567",
                       email:        "new_user@email.com" }
  end

  test "should create reservation" do

    assert_difference "Reservation.count" do
      post :create, reservation: @reservation_attrs.merge(visitor_attributes: @visitor_attrs)
    end

    assert_redirected_to reservations_path, flash[:notice]

  end

end
