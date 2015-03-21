class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order 'position' }
  has_secure_password validations: false
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 8

  def update_my_queue_positions
    self.queue_items.each_with_index do |item, index|
      item.update(position: index + 1)
    end
  end
end
