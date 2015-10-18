# == Schema Information
#
# Table name: hotels
#
#  id                 :integer          not null, primary key
#  title              :string
#  breakfast_included :boolean
#  room_description   :text
#  room_price         :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  image              :string
#  rating             :decimal(, )      default(0.0)
#

require 'rails_helper'

RSpec.describe Hotel, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:address).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  context 'validations' do

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(2).is_at_most(40) }

    it { should validate_presence_of(:room_description) }
    it { should validate_length_of(:room_description).is_at_least(4).is_at_most(140) }

    it { should validate_presence_of(:room_price) }

  end

  context 'scopes' do
    before(:all) do
      @hotel_1 = FactoryGirl.create(:hotel, :rating => 3)
      @hotel_2  = FactoryGirl.create(:hotel, :rating => 2)
      @hotel_3  = FactoryGirl.create(:hotel, :rating => 5)
    end

    it "should return Reviews in the rating DESC order" do
      expect Hotel.higher_rating == [@hotel_3, @hotel_1, @hotel_2]
    end
  end

  context '#recalculate_rating' do
    before do
      @hotel = FactoryGirl.create(:hotel)

      @review_1 = FactoryGirl.create(:review, hotel: @hotel)
      @review_2 = FactoryGirl.create(:review, hotel: @hotel)
    end

    it 'should recalculate rating to a new value' do
      @hotel.recalculate_rating
      expect(@hotel.rating).to eq @hotel.reviews.average(:rating).round(3)
    end

    it 'should recalculate rating to a 0 value' do
      @review_1.delete
      @review_2.delete
      @hotel.reload
      @hotel.recalculate_rating
      expect(@hotel.rating).to eq 0
    end
  end

  context '#reviewed_by?' do
    before do
      @hotel = FactoryGirl.create(:hotel)
      @user = FactoryGirl.create(:user)

      @review = FactoryGirl.create(:review, hotel: @hotel, user: @user)
    end

    it 'should return true if find review by user' do
      expect(@hotel.reviewed_by?( @user )).to eq true
    end

    it 'should return false if not find review by user' do
      @review.delete
      @hotel.reload
      expect(@hotel.reviewed_by?( @user )).to eq false
    end
  end
end
