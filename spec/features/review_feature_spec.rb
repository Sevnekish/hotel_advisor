require 'rails_helper'

RSpec.feature "Review", type: :feature do
  let(:valid_attributes) { {
      rating: 4,
      body: "Test comment"
    }
  }

  before (:each) do
    @address_1 = FactoryGirl.create(:address)
    @hotel_1 = FactoryGirl.create(:hotel, address: @address_1)
    login_as(@hotel_1.user, :scope => :user)
  end

  feature "Add new" do
    before (:each) do
      visit "/hotels/#{@hotel_1.id}/reviews/new"
    end

    it { should have_content("Rating") }
    it { should have_content("Comment") }
    it { should have_content("Create Review") }

    scenario 'with logged in user', :js => true do
      fill_in :name => "review[rating]", with => valid_attributes[:rating]
      fill_in 'Comment', :with => valid_attributes[:body]

      click_button 'Create Review'

      expect(current_path).to eql("/hotels/#{@hotel_1.id}")

      should have_content 'New review added successfully!'

      should have_content valid_attributes[:body]

      should have_link 'Edit'
      should have_link 'Delete'

    end

    scenario "with logged out user" do
      logout(:user)
      visit "/hotels/#{@hotel_1.id}/reviews/new"
      expect(current_path).to eql('/users/sign_in')
      should have_content 'You need to sign in or sign up before continuing.'
    end
  end

  feature 'Edit' do

  end

  feature 'Delete' do

  end

end