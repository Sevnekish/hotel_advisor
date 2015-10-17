class StaticPagesController < ApplicationController
  def home
    @hotels = Hotel.higher_rating.first(5)
    @reviews = Review.all.first(5)
  end
end
