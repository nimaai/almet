require 'test_helper.rb'

class VisitorTest < ActiveSupport::TestCase

  def setup
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

  test 'creation of a new visitor' do

    v = Visitor.new @visitor_attrs
    assert v.save
    assert v.persisted?

  end

  test 'validation of presence of phone if mobile provided' do

    @visitor_attrs.delete(:phone)
    v = Visitor.new @visitor_attrs
    assert v.save
    assert v.persisted?

  end

  test 'validation of presence of mobile if phone provided' do

    @visitor_attrs.delete(:mobile)
    v = Visitor.new @visitor_attrs
    assert v.save
    assert v.persisted?

  end

  test 'validation of presence of phone and mobile' do

    @visitor_attrs.delete(:phone)
    @visitor_attrs.delete(:mobile)
    v = Visitor.new @visitor_attrs
    assert_not v.save
    assert_not v.persisted?

  end

end
