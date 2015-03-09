class ReservationsControllerTest < ActionController::TestCase

  def setup
    @reservation_attrs = { arrival:            Date.today + 1,
                           departure:          Date.tomorrow + 1,
                           adults:             2,
                           bedclothes_service: true }

    @visitor_attrs = { firstname:    'FirstnameX',
                       lastname:     'LastnameX',
                       street:       'StreetX 13',
                       zip:          'ZipX', city:         'CityX',
                       country:      'CountryX',
                       mobile:       '0904123456',
                       phone:        '0411234567',
                       email:        'new_user@email.com' }
  end

  test 'root_path' do
    assert_recognizes({ controller: 'reservations',
                        action: 'index',
                        future: true },
                      root_path)
  end

  test 'show reservation details' do
    reservation = Reservation.order('RANDOM()').first
    get :show, id: reservation.id
    r = assigns(:reservation)
    assert_equal r.id, reservation.id
    assert r.visitor
    assert_template :show
  end

  test 'new should initialize reservation and visitor' do
    get :new
    r = assigns(:reservation)
    assert r
    assert r.visitor
  end

  test 'should get index of future and present reservations' do

    get :index, future: 'true'

    assert_response :success
    assert_not_nil assigns(:present_reservation)
    assert_not_nil assigns(:reservations)

    present_reservation = assigns(:present_reservation)
    reservations = assigns(:reservations)

    # test order of future reservations: next reservation should be first
    next_reservation = Reservation.future.first
    assert_equal reservations.first, next_reservation

    # test partial
    assert_template :index
    assert_template layout: 'layouts/application', partial: '_present_reservation'
    assert_template layout: 'layouts/application', partial: '_reservations'
    assert_template layout: 'layouts/application', partial: '_reservation_line'

    assert_select 'h3', 'Present reservation'
    assert_select 'h3', 'Future reservations'

    # test availability of columns
    assert_select 'table thead' do
      assert_select 'th:nth-child(1)', '#'
      assert_select 'th:nth-child(2)', 'Arrival'
      assert_select 'th:nth-child(3)', 'Departure'
      assert_select 'th:nth-child(4)', 'Adults'
      assert_select 'th:nth-child(5)', 'Children'
      assert_select 'th:nth-child(6)', 'Bedclothes Service'
      assert_select 'th:nth-child(7)', 'Visitor'
    end

    assert_select 'table#present-reservation tbody' do
      assert_select 'tr td:nth-child(1)', 1
      assert_select 'tr td:nth-child(2)', I18n.l(present_reservation.arrival)
      assert_select 'tr td:nth-child(3)', I18n.l(present_reservation.departure)
      assert_select 'tr td:nth-child(4)', present_reservation.adults.to_s
      assert_select 'tr td:nth-child(5)', present_reservation.children.to_s
      assert_select 'tr td:nth-child(6)',
                    (present_reservation.bedclothes_service ? 'Yes' : 'No')

      assert_select 'tr td:nth-child(7)', present_reservation.visitor.fullname
      assert_select 'tr td:nth-child(8)' do
        assert_select "a[href='#{reservation_path(present_reservation.id)}']",
                      'Show'
        assert_select "a[href='#{reservation_path(present_reservation.id)}']",
                      'Delete'
      end
    end

    # test numbering of future reservation lines starting with 1
    # and increasing & content of lines
    assert_select 'table#reservations tbody' do
      assert_select 'tr' do |lines|
        lines.each_with_index do |line, i|
          assert_select line, 'td:nth-child(1)', number: i + 1
          assert_select line, 'td:nth-child(2)', I18n.l(reservations[i].arrival)
          assert_select line, 'td:nth-child(3)', I18n.l(reservations[i].departure)
          assert_select line, 'td:nth-child(4)', reservations[i].adults.to_s
          assert_select line, 'td:nth-child(5)', reservations[i].children.to_s
          assert_select line,
                        'td:nth-child(6)',
                        (reservations[i].bedclothes_service ? 'Yes' : 'No')

          assert_select line, 'td:nth-child(7)', reservations[i].visitor.fullname
          assert_select line, 'td:nth-child(8)' do
            assert_select "a[href='#{reservation_path(reservations[i].id)}']",
                          'Delete'
          end
        end
      end
    end

  end

  test 'past reservations' do
    get :index, past: 'true'
    assert_template :index
    assert_select 'table tbody tr', Reservation.past.count
    assert_select 'h3', 'Past reservations'
  end

  test 'creation with a new visitor' do
    assert_difference 'Reservation.count' do
      post :create,
           reservation: @reservation_attrs,
           visitor: @visitor_attrs
    end

    assert_redirected_to reservations_path(future: true)
    assert_not_nil flash[:success]
  end

  test 'creation with an existing visitor' do
    visitor = Visitor.order('RANDOM()').first
    @visitor_attrs[:email] = visitor.email

    assert_difference 'Reservation.count' do
      post :create,
           reservation: @reservation_attrs,
           visitor: @visitor_attrs
    end

    assert_redirected_to reservations_path(future: true)
    assert_not_nil flash[:success]
  end

  test 'creation with an existing visitor using visitor_id' do
    visitor = Visitor.order('RANDOM()').first
    @reservation_attrs[:visitor_id] = visitor.id

    assert_difference 'Reservation.count' do
      post :create, reservation: @reservation_attrs
    end

    assert_redirected_to reservations_path(future: true)
    assert_not_nil flash[:success]
  end

end
