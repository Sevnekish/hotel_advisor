require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home" do
    before do
      FactoryGirl.create_list(:hotel, 10)
      FactoryGirl.create_list(:review, 10)
      get :home
    end

    it { should render_template('home') }

    it "should assert top 5 hotels" do
      expect assigns(:hotels) == Hotel.higher_rating.first(5)
    end

    it "should assert last 5 reviews" do
      expect assigns(:reviews) == Review.all.first(5)
    end
  end

end