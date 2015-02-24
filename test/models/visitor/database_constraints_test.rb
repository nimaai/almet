require 'test_helper.rb'

class DatabaseConstraintsTest < ActiveSupport::TestCase

  self.use_transactional_fixtures = false

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

  test 'creation of a new visitor without reservation raises exception' do

    v = Visitor.new @visitor_attrs

    assert_raises(ActiveRecord::StatementInvalid) do
      v.save
    end

    assert_not v.persisted?

  end
end
