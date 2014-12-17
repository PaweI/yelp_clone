class Restaurant < ActiveRecord::Base

  has_many :reviews, dependent: :destroy# check id of user created review

  belongs_to :user


  validates :name, length: {minimum: 3}, uniqueness: true
  # validates :user_id, uniqueness: true

end
