require_relative "../../lib/tokenable.rb"

class Invitation < ActiveRecord::Base
  include Tokenable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :friend_email, format: { with: VALID_EMAIL_REGEX },
    presence: true
  validates :friend_name, presence: true
  validates :message, presence: true
end
