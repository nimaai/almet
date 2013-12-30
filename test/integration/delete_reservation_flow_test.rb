require 'test_helper'

class DeleteReservationFlowTest < ActionDispatch::IntegrationTest

  def shared_steps
    assert_difference("Reservation.count", -1) do
      delete_via_redirect reservation_path(@r), nil, { referer: reservations_path }
    end
    assert_response :success
    assert_template :index, flash[:success]
    assert_raises(ActiveRecord::RecordNotFound) { @r.reload }
  end

  test "delete future reservation" do
    @r = Reservation.future.first
    shared_steps
  end

  test "delete present reservation" do
    @r = Reservation.present
    shared_steps
  end
end
