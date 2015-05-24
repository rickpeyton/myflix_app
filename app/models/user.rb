require_relative "../../lib/tokenable.rb"

class User < ActiveRecord::Base
  include Tokenable
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :queue_items, -> { order 'position' }
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :leading_relationships, class_name: "Relationship", foreign_key: "leader_id"
  has_secure_password validations: false
  validates_presence_of :name
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 8

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  def update_my_queue_positions
    self.queue_items.each_with_index do |item, index|
      item.update(position: index + 1)
    end
  end

  def follows?(another_user)
    following_relationships.map(&:leader_id).include?(another_user.id)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user)) && self != another_user
  end

  def deactivate!
    self.update_column(:active, false)
  end
end
