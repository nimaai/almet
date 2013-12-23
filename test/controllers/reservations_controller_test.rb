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

  test "should create reservation" do

    @request.env['HTTP_REFERER'] = new_reservation_path

    assert_difference "Reservation.count" do
      post :create, reservation: @reservation_attrs.merge(visitor_attributes: @visitor_attrs)
    end

    assert_redirected_to reservations_path, flash[:notice]

  end

  test "should get index of reservations" do

    get :index

    assert_response :success
    assert_not_nil assigns(:reservations)

    next_reservation = Reservation.order(:arrival).first
    assert_equal assigns(:reservations).first, next_reservation

    assert_template :index
    assert_template layout: "layouts/application", partial: "_reservation"

    assert_select "table tbody tr" do |lines|
      lines.each_with_index do |line, i|
        assert_select line, ":first-child", number: i + 1
      end
    end

  end

end
