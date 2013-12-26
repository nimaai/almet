require 'test_helper'

class CreateReservationFlowTest < ActionDispatch::IntegrationTest

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
    get new_reservation_path
    assert_response :success
    assert_template :new
    post_via_redirect reservations_path, reservation: @reservation_attrs.merge(visitor_attributes: @visitor_attrs)
    assert_equal reservations_path, path
    assert_select ".alert-success", "New reservation successfully created"
  end

end
