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

    assert_difference "Reservation.count" do
      post :create, reservation: @reservation_attrs.merge(visitor_attributes: @visitor_attrs)
    end

  end

  test "should get index of reservations" do

    get :index

    assert_response :success
    assert_not_nil assigns(:reservations)

    # test order: next reservation should be first
    next_reservation = Reservation.order(:arrival).first
    reservations = assigns(:reservations)
    assert_equal reservations.first, next_reservation

    # test partial
    assert_template :index
    assert_template layout: "layouts/application", partial: "_reservation"

    # test availability of columns
    assert_select "table thead th:nth-child(1)", "#"
    assert_select "table thead th:nth-child(2)", "Arrival"
    assert_select "table thead th:nth-child(3)", "Departure"
    assert_select "table thead th:nth-child(4)", "Adults"
    assert_select "table thead th:nth-child(5)", "Children"
    assert_select "table thead th:nth-child(6)", "Bedclothes Service"
    assert_select "table thead th:nth-child(7)", "Visitor"

    # test numbering of reservation lines starting with 1 and increasing & content of lines
    assert_select "table tbody tr" do |lines|
      lines.each_with_index do |line, i|
        assert_select line, "td:nth-child(1)", number: i + 1
        assert_select line, "td:nth-child(2)", reservations[i].arrival.to_s
        assert_select line, "td:nth-child(3)", reservations[i].departure.to_s
        assert_select line, "td:nth-child(4)", reservations[i].adults.to_s
        assert_select line, "td:nth-child(5)", reservations[i].children.to_s
        assert_select line, "td:nth-child(6)", (reservations[i].bedclothes_service ? "Yes" : "No")
        assert_select line, "td:nth-child(7)", reservations[i].visitor.fullname
      end
    end

  end

end
