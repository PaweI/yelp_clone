class Restaurant < ActiveRecord::Base

  has_many :reviews, dependent: :destroy# check id of user created review

  belongs_to :user


  validates :name, length: {minimum: 3}, uniqueness: true
  # validates :user_id, uniqueness: true


  def average_rating
    return 'N/A' if reviews.none?
    reviews.average(:rating)
  end
end
