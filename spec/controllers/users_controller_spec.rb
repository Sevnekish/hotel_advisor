require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user_1) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user) }

  before (:each) do
    sign_in user_1
  end

  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:correct_user) }

  describe "GET #show" do

    context 'when logged in' do

      it "renders the show template for current user" do
        get :show, id: user_1
        expect(response).to render_template("show")
      end

      it "redirect to the root_url if not current user" do
        get :show, id: user_2
        expect(response).to redirect_to root_url
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        get :show, id: user_1
        expect(response).to redirect_to new_user_session_path
      end

    end

  end
  
end
