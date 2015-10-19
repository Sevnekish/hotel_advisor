require 'rails_helper'

RSpec.describe HotelsController, type: :controller do

  let(:user_1) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user) }

  let(:hotel_1) { FactoryGirl.create(:hotel, user: user_1) }
  let(:hotel_2) { FactoryGirl.create(:hotel, user: user_2) }

  let(:review_1) { FactoryGirl.create(:review, user: user_1, hotel: hotel_1) }
  let(:review_2) { FactoryGirl.create(:review, user: user_2, hotel: hotel_1) }

  let(:valid_attributes) { FactoryGirl.build(:hotel).attributes }
  let(:invalid_attributes) { FactoryGirl.build(:hotel, title: nil).attributes }

  before (:each) do
    sign_in user_1
  end

  it { should use_before_action(:find_hotel) }
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:correct_user) }

  describe "GET #index" do
    before do
      FactoryGirl.create_list(:hotel, 20)
      @page = 1
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "should assert hotels" do
      expect assigns(:hotels) == Hotel.higher_rating.paginate(page: @page, :per_page => 8)
    end

  end

  describe "POST #create" do

    context 'when logged in' do

      describe 'with valid params' do
        it 'creates a new hotel' do
          expect {
            post :create, hotel: valid_attributes
          }.to change(Hotel, :count).by(1)
        end

        it 'assigns a newly created hotel as @hotel' do
          post :create, hotel: valid_attributes
          expect(assigns(:hotel)).to be_a(Hotel)
          expect(assigns(:hotel)).to be_persisted
        end

        it 'redirects to the created hotel and set flash' do
          post :create, hotel: valid_attributes
          expect(response).to redirect_to(hotel_path(Hotel.last))
          should set_flash[:success].to("New hotel added successfully!")
        end

      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved hotel as @hotel' do
          expect {
            post :create, hotel: invalid_attributes
          }.to change(Hotel, :count).by(0)
        end

        it 're-renders the new template' do
          post :create, hotel: invalid_attributes
          expect(response).to render_template('new')
        end
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        post :create, hotel: valid_attributes
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe "GET #new" do

    context 'when logged in' do

      it "renders the new template for current user" do
        get :new
        expect(response).to render_template("new")
      end

      it "should assert hotel" do
        expect assigns(:hotels) == user_1.hotels.build.build_address
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe "GET #edit" do

    context 'when logged in' do

      it "renders the edit template for current hotel" do
        get :edit, id: hotel_1
        expect(response).to render_template("edit")
      end

      it "should assert hotel" do
        expect assigns(:hotel) == hotel_1
      end

      it "redirect to the root_url if not current user" do
        get :edit, id: hotel_2
        expect(response).to redirect_to root_url
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        get :edit, id: hotel_1
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe "GET #show" do

    it "renders the show template" do
      get :show, id: hotel_1
      expect(response).to render_template("show")
    end

  end

  describe "PATCH #update" do

    context 'when logged in' do

      describe 'with valid params' do
        before { @title = 'new title' }

        it 'updates the requested hotel' do
          put :update, id: hotel_1.id, hotel: { 'title' => @title }
          hotel_1.reload
          expect(hotel_1.title).to eq(@title)
          expect(response).to redirect_to(hotel_path(hotel_1))
          should set_flash[:success].to("Hotel updated successfully!")
        end

        it "redirect to the root_url if not current user" do
          put :update, id: hotel_2, hotel: { 'title' => @title }
          expect(response).to redirect_to root_url
        end

      end

      describe 'with invalid params' do
        it 're-renders the edit template' do
          put :update, id: hotel_1, hotel: { 'title' => nil }
          expect(response).to render_template('edit')
        end
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        put :update, id: hotel_1, hotel: { 'title' => @title }
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

  describe "DELETE #destroy" do
    before { @hotel = FactoryGirl.create(:hotel, user: user_1) }

    context 'when logged in' do

      it 'destroys the requested hotel' do
        expect {
          delete :destroy, id: @hotel
        }.to change(Hotel.all, :count).by(-1)
      end

      it 'redirects to the hotels list' do
        delete :destroy, id: @hotel
        expect(response).to redirect_to(hotels_path)
      end

      it "redirect to the root_url if not current user" do
        delete :update, id: hotel_2
        expect(response).to redirect_to root_url
      end

    end

    context 'when logged out' do
      before do
        sign_out user_1
      end

      it "redirect to the new_user_session" do
        delete :update, id: @hotel
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

end
