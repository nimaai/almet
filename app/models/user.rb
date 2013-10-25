class User < ActiveRecord::Base
  has_many :reservation
end
