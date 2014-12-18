module ReviewsHelper

  def star_rating(rating)
    return rating unless rating.is_a?(Fixnum)
    '★' * rating
    remainder = (5 - rating)
    "★" * rating + "☆" * remainder
  end

end
