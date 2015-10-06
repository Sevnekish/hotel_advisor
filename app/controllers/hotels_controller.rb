class HotelsController < ApplicationController
  before_action :find_hotel, only: [:show, :edit, :update, :destroy]

  def index
    @hotels = Hotel.all.order("created_at DESC")
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(hotel_params)

    if @hotel.save
      redirect_to root_path
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
                                    :room_price
                                    )
    end

    def find_hotel
      @hotel = Hotel.find(params[:id])
    end
end
