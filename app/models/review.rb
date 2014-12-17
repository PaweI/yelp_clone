class Review < ActiveRecord::Base

  belongs_to :restaurant #:user

  validates :rating, inclusion: (1..5)

end
