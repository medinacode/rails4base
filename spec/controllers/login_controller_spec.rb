require 'rails_helper'

RSpec.describe LoginController, :type => :controller do

  describe "GET login" do
    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "POST do" do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it 'logs in with correct email address and password' do
      post :do, { email_address: @user.email_address, password: @user.password }
      expect(session[:user_id]).to eq @user.id
      expect(response).to redirect_to :home
    end

    it 'does not login with bad email address' do
      post :do, { email_address: nil, password: @user.password }
      expect(response).to redirect_to login_path
    end

    it 'does not login with bad password' do
      post :do, { email_address: @user.email_address, password: nil }
      expect(response).to redirect_to login_path
    end

  end

end
