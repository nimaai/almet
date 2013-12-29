require 'test_helper'

class DeleteReservationFlowTest < ActionDispatch::IntegrationTest

  test "delete reservation" do
    r = Reservation.future.first
    assert_difference("Reservation.count", -1) do
      delete_via_redirect reservation_path(r), nil, { referer: reservations_path }
    end
    assert_response :success
    assert_template :index, flash[:success]
    assert_raises(ActiveRecord::RecordNotFound) { r.reload }
  end

end
