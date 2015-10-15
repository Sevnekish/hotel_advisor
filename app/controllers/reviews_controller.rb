class ReviewsController < ApplicationController
  before_action :find_hotel
  before_action :find_review, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!

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

  def edit
  end

  def destroy
    @review.destroy
    redirect_to hotel_path(@hotel)
  end

  def update
    if @review.update(review_params)
      redirect_to hotel_path(@hotel)
    else
      render 'edit'
    end
  end

  private

    def review_params
      params.require(:review).permit(:rating, :body)
    end

    def find_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end

    def find_review
      @review = Review.find(params[:id])
    end
end
