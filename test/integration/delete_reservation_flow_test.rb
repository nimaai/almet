require 'test_helper'

class DeleteReservationFlowTest < ActionDispatch::IntegrationTest

  def shared_steps
    assert_difference("Reservation.count", -1) do
      delete_via_redirect reservation_path(@r), nil, { referer: reservations_path }
    end
    assert_response :success
    assert_template :index, flash[:success]
  end

  test "delete future reservation" do
    @r = Reservation.future.first
    shared_steps
    assert_template layout: "layouts/application", partial: "_reservations"
    assert_raises(ActiveRecord::RecordNotFound) { @r.reload }
  end

  test "delete present reservation" do
    @r = Reservation.present
    shared_steps
    assert_template layout: "layouts/application", partial: "_present_reservation"
    assert_template layout: "layouts/application", partial: "_reservations"
    assert_raises(ActiveRecord::RecordNotFound) { @r.reload }
  end
end
