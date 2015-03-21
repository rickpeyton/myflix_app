class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :description
  validates_presence_of :rating
  validates_numericality_of :rating, only_integer: true,
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
end
