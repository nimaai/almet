require 'test_helper'

class CreateReservationFlowTest < ActionDispatch::IntegrationTest

  def setup
    @reservation_attrs = { arrival:            Date.today + 1,
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

  test 'create new reservation' do
    get new_reservation_path
    assert_response :success
    assert_template :new
    assert_difference('Reservation.count', +1) do
      post_via_redirect \
        reservations_path(future: true),
        reservation: @reservation_attrs,
        visitor: @visitor_attrs
    end
    assert_select '.alert-success'

    index_reservations = Reservation.future.count
    index_reservations += 1 if Reservation.present
    assert_select 'table tbody tr', index_reservations
  end

end
