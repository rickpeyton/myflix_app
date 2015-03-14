class User < ActiveRecord::Base
  has_many :reviews
  has_secure_password validations: false
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 8
end
