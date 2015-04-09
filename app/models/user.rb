class User < ActiveRecord::Base
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :queue_items, -> { order 'position' }
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
end
