class ReviewsController < ApplicationController
  before_action :find_hotel
  before_action :find_review, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.hotel_id = @hotel.id
    @review.user_id = current_user.id

    if @review.save
      flash[:success] = "New review added successfully!"
      redirect_to hotel_path(@hotel)
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy
    if @review.destroy
      flash[:success] = "Review deleted successfully!"
      redirect_to hotel_path(@hotel)
    else
      redirect_to hotel_path(@hotel)
    end
  end

  def update
    if @review.update(review_params)
      flash[:success] = "Review updated successfully!"
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

    def correct_user
      @review = current_user.reviews.find_by(id: params[:id])
      redirect_to root_url if @review.nil?
    end
end
