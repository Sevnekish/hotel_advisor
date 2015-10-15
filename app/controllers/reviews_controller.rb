class ReviewsController < ApplicationController
  before_action :find_hotel
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.hotel_id = @hotel.id
    @review.user_id = current_user.id

    if @review.save
      redirect_to hotel_path(@hotel)
    else
      render 'new'
    end
  end

  private

    def review_params
      params.require(:review).permit(:rating, :body)
    end

    def find_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end
end
