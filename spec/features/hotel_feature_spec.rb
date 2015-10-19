require 'rails_helper'

RSpec.feature "Hotel", type: :feature do
  let(:valid_attributes) { {
      title:            'Test hotel',
      room_description: 'Test room',
      room_price:       399,
      country:          'Test Country',
      state:            'Test state',
      city:             'Test city',
      street:           'Test street'
    }
  }

  let(:user_1) { FactoryGirl.create(:user) }

  feature "Add new" do

    before (:each) do
      login_as(user_1, :scope => :user)
      visit '/hotels/new'
    end

    subject { page }

    it { should have_content("Hotel name") }
    it { should have_content("Breakfast included") }
    it { should have_content("Room description") }
    it { should have_content("Price") }
    it { should have_content("Image") }
    it { should have_content("Country") }
    it { should have_content("State") }
    it { should have_content("City") }
    it { should have_content("Street") }

    scenario 'with logged in user' do
      fill_in 'Hotel name',       :with => valid_attributes[:title]
      fill_in 'Room description', :with => valid_attributes[:room_description]
      fill_in 'Price',            :with => valid_attributes[:room_price]
      fill_in 'Country',          :with => valid_attributes[:country]
      fill_in 'State',            :with => valid_attributes[:state]
      fill_in 'City',             :with => valid_attributes[:city]
      fill_in 'Street',           :with => valid_attributes[:street]

      click_button 'Create Hotel'

      expect(current_path).to eql("/hotels/1")

      should have_content 'New hotel added successfully!'

      should have_content valid_attributes[:title]
      should have_content valid_attributes[:room_description]
      should have_content valid_attributes[:room_price]
      should have_content valid_attributes[:country]
      should have_content valid_attributes[:state]
      should have_content valid_attributes[:city]
      should have_content valid_attributes[:street]

      should have_link 'Edit hotel'
      should have_link 'Delete hotel'
      should have_link 'Add Review'

    end

    scenario "with logged out user" do
      logout(:user)
      visit '/hotels/new'
      expect(current_path).to eql('/users/sign_in')
      should have_content 'You need to sign in or sign up before continuing.'
    end
  end

  feature 'Edit' do

    before (:each) do
      # login_as(user_1, :scope => :user)
      @address_1 = FactoryGirl.create(:address)
      @hotel_1 = FactoryGirl.create(:hotel, address: @address_1)
      login_as(@hotel_1.user, :scope => :user)
      @new_title = "New Title"
      visit "/hotels/#{@hotel_1.id}/edit"
    end

    subject { page }

    it { should have_content("Hotel name") }
    it { should have_content("Breakfast included") }
    it { should have_content("Room description") }
    it { should have_content("Price") }
    it { should have_content("Image") }
    it { should have_content("Country") }

    scenario 'with logged in user' do
      fill_in 'Hotel name',       :with => @new_title

      click_button 'Update Hotel'

      expect(current_path).to eql("/hotels/#{@hotel_1.id}")

      should have_content 'Hotel updated successfully!'
      should have_content @new_title
    end

    scenario "with logged out user" do
      logout(:user)
      visit "/hotels/#{@hotel_1.id}/edit"
      expect(current_path).to eql('/users/sign_in')
      should have_content 'You need to sign in or sign up before continuing.'
    end
  end

  feature 'Delete' do

    before (:each) do
      @address_1 = FactoryGirl.create(:address)
      @hotel_1 = FactoryGirl.create(:hotel, address: @address_1)
      login_as(@hotel_1.user, :scope => :user)
    end

    subject { page }

    scenario 'with logged in user' do
      visit "/hotels/#{@hotel_1.id}"

      click_link 'Delete hotel'

      expect(current_path).to eql("/hotels")

      should have_content 'Hotel deleted successfully!'
    end

    scenario "with logged out user" do
      logout(:user)
      visit "/hotels/#{@hotel_1.id}"
      should_not have_link 'Edit hotel'
      should_not have_link 'Delete hotel'
    end
  end

end