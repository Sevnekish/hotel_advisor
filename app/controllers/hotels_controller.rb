class HotelsController < ApplicationController
  before_action :find_hotel, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def index
    @hotels = Hotel.higher_rating.order("created_at DESC").paginate(page: params[:page], :per_page => 8)
  end

  def new
    @hotel = current_user.hotels.build
    @hotel.build_address
  end

  def create
    @hotel = current_user.hotels.build(hotel_params)

    if @hotel.save
      flash[:success] = "New hotel added successfully!"
      redirect_to hotel_path(@hotel)
    else
      render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @hotel.update(hotel_params)
      flash[:success] = "Hotel updated successfully!"
      redirect_to hotel_path(@hotel)
    else
      render 'edit'
    end
  end

  def destroy
    if @hotel.destroy
      flash[:success] = "Hotel deleted successfully!"
      redirect_to hotels_path
    else
      redirect_to hotel_path(@hotel)
    end
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

    def correct_user
      @hotel = current_user.hotels.find_by(id: params[:id])
      redirect_to root_url if @hotel.nil?
    end
end
