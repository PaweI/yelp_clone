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
  
end

