require 'byebug'
class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if !current_user
      flash[:alert] = 'You must be logged in to write a review.'
      redirect_to restaurants_path
    elsif @restaurant.reviews.map(&:user_id).include? current_user.id
      flash[:alert] = 'You have already reviewed this restaurant.'
      redirect_to restaurants_path
    else
      @review = Review.new
    end
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(review_params)
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating, :user_id)
  end

# REVIEWS ARE NOT BEING ASSIGNED USER IDS. 
  
end

# (byebug) @restaurant.reviews.map(&:user_id).include? current_user.id
# false
# (byebug) Review.first
#   #<Review id: 39, thoughts: "rubbish", rating: 4, created_at: "2014-12-17 19:03:21", updated_at: "2014-12-17 19:03:21", restaurant_id: 1, user_id: nil>
# (byebug) @restaurant.id
# 292
# (byebug) Review.all.map &:id
# [39]
# (byebug) Review.all.map &:restaurant_id