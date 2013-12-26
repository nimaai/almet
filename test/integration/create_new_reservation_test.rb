class ReservationsControllerTest < ActionController::TestCase

  def setup
    @reservation_attrs = { arrival:            Date.today.to_s,
                           departure:          Date.tomorrow.to_s,
                           adults:             2,
                           bedclothes_service: true }

    @visitor_attrs = { firstname:    "FirstnameX",
                       lastname:     "LastnameX",
                       street:       "StreetX 13",
                       zip:          "ZipX", city:         "CityX",
                       country:      "CountryX",
                       mobile:       "0904123456",
                       phone:        "0411234567",
                       email:        "new_user@email.com" }
  end

  test "create new reservation" do
    @request.env['HTTP_REFERER'] = new_reservation_path
    post :create, reservation: @reservation_attrs.merge(visitor_attributes: @visitor_attrs)
    assert_redirected_to reservations_path, flash[:notice]
    assert_select ".alert-success", "New reservation successfully created"
  end

end
