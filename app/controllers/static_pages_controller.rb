class StaticPagesController < ApplicationController
  def help
  end

  def home
    @hotels = Hotel.higher_rating.first(5)
    @reviews = Review.all.first(5)
  end
end
