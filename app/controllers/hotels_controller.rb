class HotelsController < ApplicationController
  before_action :find_hotel, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  #TODO: add before filter, where check if user is current_user for edit, update and destroy actions

  def index
    @hotels = Hotel.all.order("created_at DESC").paginate(page: params[:page], :per_page => 3)
  end

  def new
    @hotel = current_user.hotels.build
    @hotel.build_address
  end

  def create
    @hotel = current_user.hotels.build(hotel_params)

    if @hotel.save
      redirect_to hotels_path
    else
      # redirect_to new_hotel_path
      render 'new'
    end
  end

  def edit
  end

  def show
    if @hotel.reviews.blank?
      @average_rating = 0
    else
      @average_rating = @hotel.reviews.average(:rating).round(2)
    end
  end

  def update
    if @hotel.update(hotel_params)
      redirect_to hotel_path(@hotel)
    else
      render 'edit'
    end
  end

  def destroy
    @hotel.destroy
    redirect_to hotels_path
  end

  private

    def hotel_params
      params.require(:hotel).permit(
                                    :title,
                                    :breakfast_included,
                                    :room_description,
                                    :room_price,
                                    :image,
                                    address_attributes: [
                                      :country,
                                      :state,
                                      :city,
                                      :street
                                      ]
                                    )
    end

    def find_hotel
      @hotel = Hotel.find(params[:id])
    end
end
