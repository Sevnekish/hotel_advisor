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

  feature "Add new", :js => true do
    before (:each) do
      visit "/hotels/#{@hotel_1.id}/reviews/new"
    end

    subject { page }

    it { should have_content("Rating") }
    it { should have_content("Comment") }

    scenario 'with logged in user' do
      # fill_in :name => "review[rating]", :with => valid_attributes[:rating]
      # find(:xpath, "//input[@name='review[rating]'").set(valid_attributes[:rating])
      page.execute_script("$('#rating-input').find('input').val(#{valid_attributes[:rating]})")
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

  feature 'Edit', :js => true do
    before (:each) do
      @new_comment = "New comment"
      @review_1 = FactoryGirl.create(:review, hotel: @hotel_1, user: @hotel_1.user)
      visit "/hotels/#{@hotel_1.id}/reviews/#{@review_1.id}/edit"
    end

    subject { page }

    it { should have_content("Rating") }
    it { should have_content("Comment") }

    scenario 'with logged in user' do

      page.execute_script("$('#rating-input').find('input').val(3)")
      fill_in 'Comment', :with => @new_comment

      click_button 'Update Review'

      expect(current_path).to eql("/hotels/#{@hotel_1.id}")

      should have_content 'Review updated successfully!'

      should have_content @new_comment

      should have_link 'Edit'
      should have_link 'Delete'

    end
  end

  feature 'Delete' do
    before (:each) do
      @review_1 = FactoryGirl.create(:review, hotel: @hotel_1, user: @hotel_1.user)
      visit "/hotels/#{@hotel_1.id}"
    end

    subject { page }

    it { should have_link("Edit") }
    it { should have_link("Delete") }

    scenario 'with logged in user' do

      click_link 'Delete'

      expect(current_path).to eql("/hotels/#{@hotel_1.id}")

      should have_content 'Review deleted successfully!'

      should_not have_content @review_1.body

      should have_link 'Add Review'

    end
  end

end