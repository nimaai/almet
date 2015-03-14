class VisitorsControllerTest < ActionController::TestCase

  test 'index' do
    get :index
    visitors = assigns(:visitors)
    assert_equal \
      visitors.first,
      Visitor.all.sort_by(&:lastname).first
  end

  test 'update' do
    visitor_attrs = { firstname:    'FirstnameX',
                      lastname:     'LastnameX',
                      street:       'StreetX 13',
                      zip:          'ZipX',
                      city:         'CityX',
                      country:      'CountryX',
                      mobile:       '0904123456',
                      phone:        '0411234567' }

    visitor = Visitor.all.sample
    post :update, { id: visitor.id }.merge(visitor: visitor_attrs)
    assert_redirected_to visitors_path
    assert_not_nil flash[:success]
  end
end
