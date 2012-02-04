class User < ActiveRecord::Base
  has_many :brooms

  validates_presence_of :email, :token, :secret
end
