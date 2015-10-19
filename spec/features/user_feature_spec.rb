require 'rails_helper'

RSpec.feature "User", type: :feature do

  let(:valid_attributes) { {
      email:    "valid@mail.com",
      password: "qwerty123456",
      password_confirmation: "qwerty123456"
    }
  }
  before (:each) do
    @user_1 = FactoryGirl.create(:user, valid_attributes)
    @user_2 = FactoryGirl.create(:user)
  end

  feature "sign in" do

    before (:each) do
      visit '/users/sign_in'
    end

    subject { page }

    it { should have_link 'Sign up', count: 2  }
    it { should have_link 'Log in' }
    it { should have_content("Email") }
    it { should have_content("Password") }
    it { should have_link 'Forgot your password?' }
    it { should_not have_link 'Add hotel' }

    scenario "with existed user data" do

      fill_in 'Email', :with => valid_attributes[:email]
      fill_in 'Password', :with => valid_attributes[:password]

      click_button 'Log in'
      expect(current_path).to eql('/')

      should have_content 'Signed in successfully.'

      should have_link 'Add hotel'
      should have_link 'Logout'
      should have_link valid_attributes[:email]

      should_not have_link 'Sign up'
      should_not have_link 'Log in'
    end

    scenario "with not existed user data" do

      fill_in 'Email', :with => "notexisted@mail.com"
      fill_in 'Password', :with => valid_attributes[:password]

      click_button 'Log in'
      should have_content 'Invalid email or password'

      should have_link 'Sign up', count: 2 
      should have_link 'Log in'
    end

    scenario "when user already signed in" do
      login_as(@user_1, :scope => :user)
      visit '/users/sign_in'
      expect(current_path).to eql('/')
      should have_content 'You are already signed in.'
    end
  end

  feature "sign out" do

    before (:each) do
      login_as(@user_1, :scope => :user)

      visit '/'
    end

    subject { page }

    it { should have_link 'Logout' }

    scenario "existed user" do

      click_link 'Logout'
      should have_content 'Signed out successfully.'
      should have_link 'Sign up'
      should have_link 'Log in'
    end
  end

  feature "sign up" do
    before (:each) do
      @new_user_attr = {
        email:    "new@mail.com",
        password: "qwerty123456",
        password_confirmation: "qwerty123456"
      }
      visit '/users/sign_up'
    end

    subject { page }

    it { should have_content("Sign up") }
    it { should have_content("Email") }
    it { should have_content("Password") }
    it { should have_content("Password confirmation") }

    scenario "with valid data" do

      fill_in 'Email',                 :with => @new_user_attr[:email], :match => :prefer_exact
      fill_in 'Password',              :with => @new_user_attr[:password], :match => :prefer_exact
      fill_in 'Password confirmation', :with => @new_user_attr[:password_confirmation]

      click_button 'Sign up'
      expect(current_path).to eql('/')

      should have_content 'Welcome! You have signed up successfully.'

      should have_link 'Add hotel'
      should have_link 'Logout'
      should have_link @new_user_attr[:email]

      should_not have_link 'Sign up'
      should_not have_link 'Log in'
    end

    scenario "with already existed user data" do

      fill_in 'Email',                 :with => valid_attributes[:email]
      fill_in 'Password',              :with => valid_attributes[:password], :match => :prefer_exact
      fill_in 'Password confirmation', :with => valid_attributes[:password_confirmation]

      click_button 'Sign up'
      should have_content 'Please review the problems below:'
      should have_content 'has already been taken'

    end

    scenario "when user already signed in" do
      login_as(@user_1, :scope => :user)
      visit '/users/sign_up'
      expect(current_path).to eql('/')
      should have_content 'You are already signed in.'
    end

  end

  feature "visit profile page" do

    subject { page }

    scenario "with logged in user" do
      login_as(@user_1, :scope => :user)
      visit "/users/#{@user_1.id}"
      should have_link 'Edit profile'
      should have_content @user_1.email
    end

    scenario "with logged out user" do
      visit "/users/#{@user_1.id}"
      expect(current_path).to eql('/users/sign_in')
      should have_content 'You need to sign in or sign up before continuing.'
    end

    scenario "with another user" do
      login_as(@user_1, :scope => :user)
      visit "/users/#{@user_2.id}"
      expect(current_path).to eql('/')
    end
  end
end