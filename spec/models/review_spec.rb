# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  body       :text
#  hotel_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rating     :integer
#

require 'rails_helper'

RSpec.describe Review, type: :model do

  context 'associations' do
    it { should belong_to(:hotel) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    before do
      @hotel = FactoryGirl.create(:hotel)
      @user  = FactoryGirl.create(:user)
      FactoryGirl.create(:review, hotel: @hotel, user: @user)
    end

    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }

    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(4).is_at_most(200) }

    it { should validate_presence_of(:hotel) }
    it { should validate_presence_of(:user) }

    it { should validate_uniqueness_of(:hotel_id).scoped_to(:user_id).case_insensitive }

  end

  context 'scopes' do
    before(:all) do
      @first = FactoryGirl.create(:review, :created_at => 1.day.ago)
      @last  = FactoryGirl.create(:review, :created_at => 4.day.ago)
    end

    it "should return Reviews in the created_at DESC order" do
      expect Review.all == [@first, @last]
    end
  end

  context 'callbacks' do
    it { is_expected.to callback(:recalculate_hotel_rating).after(:create) }
    it { is_expected.to callback(:recalculate_hotel_rating).after(:update) }
    it { is_expected.to callback(:recalculate_hotel_rating).after(:destroy) }
  end
end
