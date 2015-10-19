require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  let(:user_1) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user) }

  let(:hotel_1) { FactoryGirl.create(:hotel, user: user_1) }
  let(:hotel_2) { FactoryGirl.create(:hotel, user: user_2) }
  let(:hotel_3) { FactoryGirl.create(:hotel, user: user_1) }

  let(:review_1) { FactoryGirl.create(:review, user: user_1, hotel: hotel_1) }
  let(:review_2) { FactoryGirl.create(:review, user: user_2, hotel: hotel_1) }
  let(:review_3) { FactoryGirl.create(:review, user: user_1, hotel: hotel_2) }


  let(:valid_attributes) { FactoryGirl.build(:review).attributes }
  let(:invalid_attributes) { FactoryGirl.build(:review, body: nil).attributes }

  before (:each) do
    sign_in user_1
  end

  it { should use_before_action(:find_hotel) }
  it { should use_before_action(:find_review) }
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:correct_user) }
  it { should use_before_action(:hotel_reviewed) }

  describe "GET #new" do

    context 'when logged in' do

      it "renders the new template for current user" do
        get :new, hotel_id: hotel_3
        expect(response).to render_template("new")
      end

      it "should assert hotel" do
        get :new, hotel_id: hotel_3
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "hotel reviewed redirect to hotel_path" do
        hotel = FactoryGirl.create(:hotel, user: user_1)
        review =  FactoryGirl.create(:review, user: user_1, hotel: hotel)

        get :new, hotel_id: hotel
        expect(response).to redirect_to(hotel_path(hotel))
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        get :new, hotel_id: hotel_3
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe "POST #create" do

    context 'when logged in' do

      describe 'with valid params' do
        it 'creates a new review' do
          expect {
            post :create, hotel_id: hotel_3, review: valid_attributes
          }.to change(Review, :count).by(1)
        end

        it 'assigns a newly created hotel as @hotel' do
          post :create, hotel_id: hotel_3, review: valid_attributes
          expect(assigns(:review)).to be_a(Review)
          expect(assigns(:review)).to be_persisted
        end

        it 'redirects to the hotel_path(@hotel) and set flash' do
          post :create, hotel_id: hotel_3, review: valid_attributes
          expect(response).to redirect_to(hotel_path(hotel_3))
          should set_flash[:success].to("New review added successfully!")
        end

      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved review as @hotel' do
          expect {
            post :create, hotel_id: hotel_3, review: invalid_attributes
          }.to change(Review, :count).by(0)
        end

        it 're-renders the new template' do
          post :create, hotel_id: hotel_3, review: invalid_attributes
          expect(response).to render_template('new')
        end
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        post :create, hotel_id: hotel_3, review: valid_attributes
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe "GET #edit" do

    
    context 'when logged in' do

      it "renders the edit template for current user" do
        get :edit, hotel_id: hotel_3, id: review_1
        expect(response).to render_template("edit")
      end

      it "redirect to the root_url if not current user" do
        get :edit, hotel_id: hotel_3, id: review_2
        expect(response).to redirect_to(root_url)
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        get :edit, hotel_id: hotel_3, id: review_1
        expect(response).to redirect_to new_user_session_path
      end

    end


  end


  describe "PATCH #update" do

    context 'when logged in' do
      before { @body = 'new body' }

      describe 'with valid params' do
        it 'updates the requested review' do
          put :update, hotel_id: hotel_1, id: review_1, review: { 'body' => @body }
          review_1.reload
          expect(review_1.body).to eq(@body)
          expect(response).to redirect_to(hotel_path(hotel_1))
          should set_flash[:success].to("Review updated successfully!")
        end

        it "redirect to the root_url if not current user" do
          put :update, hotel_id: hotel_1, id: review_2, review: { 'body' => @body }
          expect(response).to redirect_to(root_url)
        end
      end

      describe 'with invalid params' do
        it 're-renders the edit template' do
          put :update, hotel_id: hotel_1, id: review_1, review: { 'body' => nil }
          expect(response).to render_template('edit')
        end
      end


    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        put :update, hotel_id: hotel_1, id: review_1, review: { 'body' => @body }
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe "DELETE #destroy" do
    before do
      @hotel = FactoryGirl.create(:hotel, user: user_1)
      @review = FactoryGirl.create(:review, user: user_1, hotel: hotel_3)
    end

    context 'when logged in' do

      it 'destroys the requested review' do
        expect {
          delete :destroy, hotel_id: @hotel, id: @review
        }.to change(Review.all, :count).by(-1)
      end

      it 'redirects to the hotel' do
        delete :destroy, hotel_id: @hotel, id: @review
        expect(response).to redirect_to(hotel_path(@hotel))
      end

      it "redirect to the root_url if not current user" do
        delete :destroy, hotel_id: hotel_1, id: review_2
        expect(response).to redirect_to root_url
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        delete :destroy, hotel_id: @hotel, id: @review
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

end
