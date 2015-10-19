require 'rails_helper'

RSpec.feature "Static pages", type: :feature do
  feature "visit home page" do

    subject { page }

    scenario 'when user not logged in' do
      visit '/'

      expect(current_path).to eql('/')
      should have_content 'Top 5 hotels'
      should have_content 'Last reviews'
    end
  end
end