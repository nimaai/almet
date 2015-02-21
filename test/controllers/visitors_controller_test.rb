class VisitorsControllerTest < ActionController::TestCase
  test 'index' do
    get :index
    visitors = assigns(:visitors)
    assert_equal \
      visitors.first,
      Visitor.all.sort_by(&:lastname).first
  end
end
