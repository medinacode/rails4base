require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

describe 'Guest User' do

  describe 'GET show' do
    it 'redirects to login' do
      @user = FactoryGirl.create(:user)
      get :show, id: @user
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET index' do
    it 'redirects to login' do
      get :index
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET new' do
    it 'redirects to login' do
      get :new
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET edit' do
    it 'redirects to login' do
      @user = FactoryGirl.create(:user)
      get :edit, id: @user
      expect(response).to redirect_to login_path
    end
  end

  describe 'POST create' do
    it 'redirects to login' do
      post :create, user: attributes_for(:user)
      expect(response).to redirect_to login_path
    end
  end

  describe 'PATCH update' do
    it 'redirects to login' do
      @user = FactoryGirl.create(:user)
      patch :update, id: @user, user: attributes_for(:user)
      expect(response).to redirect_to login_path
    end
  end

  describe 'DELETE destroy' do
    it 'redirects to login' do
      @user = FactoryGirl.create(:user)
      delete :destroy, id: @user
      expect(response).to redirect_to login_path
    end
  end

end

describe 'Non-Admin User' do

  before :each do
    @logged_in_user = FactoryGirl.create(:user)
    session[:user_id] = @logged_in_user.id
  end

  describe 'GET show' do
    it 'redirects to logout if not this user' do
      @user = FactoryGirl.create(:user)
      get :show, id: @user
      expect(response).to redirect_to logout_path
    end

    it 'assigns the requested user' do
      get :show, id: @logged_in_user
      expect(assigns(:user)).to eq @logged_in_user
    end

    it 'renders the show template' do
      get :show, id: @logged_in_user
      expect(response).to render_template :show
    end

    it 'renders the ajax template on xhr request' do
      xhr :get, :show, id: @logged_in_user
      expect(response).to render_template :_show_ajax
    end

  end

  describe 'GET index' do
    it 'redirects to logout' do
      get :index
      expect(response).to redirect_to logout_path
    end
  end

  describe 'GET new' do
    it 'redirects to logout' do
      get :new
      expect(response).to redirect_to logout_path
    end
  end

  describe 'POST create' do
    it 'redirects to logout' do
      post :create, user: attributes_for(:user)
      expect(response).to redirect_to logout_path
    end
  end

  describe 'GET edit' do
    it 'redirects to logout if not this user' do
      @user = FactoryGirl.create(:user)
      get :show, id: @user
      expect(response).to redirect_to logout_path
    end

    it 'assigns the requested user' do
      get :edit, id: @logged_in_user
      expect(assigns(:user)).to eq @logged_in_user
    end

    it 'renders the :edit template' do
      get :edit, id: @logged_in_user
      expect(response).to render_template :edit
    end

    it 'renders the ajax template on xhr request' do
      xhr :get, :edit, id: @logged_in_user
      expect(response).to render_template :_form_ajax
    end
  end

  describe 'PATCH update' do
    it 'redirects to logout if not this user' do
      @user = FactoryGirl.create(:user)
      get :show, id: @user
      expect(response).to redirect_to logout_path
    end

    context 'with valid attributes' do
      it 'locates the requested user' do
        patch :update, id: @logged_in_user, user: attributes_for(:user)
        expect(assigns(:user)).to eq @logged_in_user
      end

      it 'changes users attributes' do
        patch :update, id: @logged_in_user, user: attributes_for(:user, full_name: 'newvalue')
        @logged_in_user.reload
        expect(@logged_in_user.full_name).to eq 'newvalue'
      end

      it 'redirects to :home' do
        patch :update, id: @logged_in_user, user: attributes_for(:user)
        expect(response).to redirect_to :home
      end

      context 'AJAX request' do
        before :each do
          xhr :patch, :update, id: @logged_in_user, user: attributes_for(:user, full_name: 'newvalue')
        end

        it 'changes users attributes' do
          @logged_in_user.reload
          expect(@logged_in_user.full_name).to eq 'newvalue'
        end

        it 'does not redirect' do
          expect(response).to_not redirect_to :home
        end

        it 'responds with success' do
          expect(JSON.parse(response.body)['success']).to eq true
        end
      end

    end

    context 'with invalid attributes' do
      it 'does not change users attributes' do
        full_name = @logged_in_user.full_name
        patch :update, id: @logged_in_user, user: attributes_for(:user, full_name: nil)
        @logged_in_user.reload
        expect(@logged_in_user.full_name).to eq full_name
      end

      it 're-renders the edit template' do
        patch :update, id: @logged_in_user, user: attributes_for(:invalid_user)
        expect(response).to render_template :edit
      end

      context 'AJAX request' do
        before :each do
          xhr :patch, :update, id: @logged_in_user, user: attributes_for(:user, full_name: nil)
        end
        it 'does not change users attributes' do
          @logged_in_user.reload
          expect(@logged_in_user.full_name).to eq @logged_in_user.full_name
        end

        it 'responds with 422 status code' do
          expect(response.code).to eq '422'
        end

        it 'responds with errors' do
          expect(JSON.parse(response.body)['errors']).to be_a_kind_of(Array)
        end
      end

    end
  end

  describe 'DELETE destroy' do
    it 'redirects to logout' do
      delete :destroy, id: @logged_in_user
      expect(response).to redirect_to logout_path
    end
  end

end

describe 'Admin User' do

    before :each do
      admin = FactoryGirl.create(:admin)
      session[:user_id] = admin.id
    end

    describe 'GET show' do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it 'assigns the requested user' do
        get :show, id: @user
        expect(assigns(:user)).to eq @user
      end

      it 'renders the show template' do
        get :show, id: @user
        expect(response).to render_template :show
      end

      it 'renders the ajax template on xhr request' do
        xhr :get, :show, id: @user
        expect(response).to render_template :_show_ajax
      end
    end

    describe 'GET index' do
      it 'assigns all users' do
        @a = FactoryGirl.create(:user)
        @b = FactoryGirl.create(:user)
        get :index
        expect(assigns(:users)).to include @a, @b
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET new' do
      it 'assigns a new user' do
        get :new
        expect(assigns(:user)).to be_a_new User
      end

      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end

      it 'renders the ajax template on xhr request' do
        xhr :get, :new
        expect(response).to render_template :_form_ajax
      end
    end

    describe 'GET edit' do
      before :each do
        @user = FactoryGirl.create(:user)
      end
      it 'assigns the requested user' do
        get :edit, id: @user
        expect(assigns(:user)).to eq @user
      end

      it 'renders the :edit template' do
        get :edit, id: @user
        expect(response).to render_template :edit
      end

      it 'renders the ajax template on xhr request' do
        xhr :get, :edit, id: @user
        expect(response).to render_template :_form_ajax
      end

    end

    describe 'POST create' do
      context 'with valid attributes' do
        it 'saves the new user' do
          expect { post :create, user: attributes_for(:user) }.to change(User, :count).by 1
        end

        it 'redirects to users index' do
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to users_path
        end

        context 'AJAX request' do
          it 'saves the new user' do
            expect { xhr :post, :create, user: attributes_for(:user) }.to change(User, :count).by 1
          end

          it 'does not redirect to users index' do
            xhr :post, :create, user: attributes_for(:user)
            expect(response).to_not redirect_to users_path
          end

          it 'responds with success' do
            xhr :post, :create, user: attributes_for(:user)
            expect(JSON.parse(response.body)['success']).to eq true
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new user' do
          expect { post :create, user: attributes_for(:invalid_user) }.to_not change(User, :count)
        end

        it 're-renders the new template' do
          post :create, user: attributes_for(:invalid_user)
          expect(response).to render_template :new
        end

        context 'AJAX request' do
          it 'does not save the new user' do
            expect { xhr :post, :create, user: attributes_for(:invalid_user) }.to_not change(User, :count)
          end

          it 'responds with 422 status code' do
            xhr :post, :create, user: attributes_for(:invalid_user)
            expect(response.code).to eq '422'
          end

          it 'responds with errors' do
            xhr :post, :create, user: attributes_for(:invalid_user)
            expect(JSON.parse(response.body)['errors']).to be_a_kind_of(Array)
          end
        end

      end
    end

    describe 'PATCH update' do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      context 'with valid attributes' do
        it 'locates the requested user' do
          patch :update, id: @user, user: attributes_for(:user)
          expect(assigns(:user)).to eq @user
        end

        it 'changes users attributes' do
          patch :update, id: @user, user: attributes_for(:user, full_name: 'newvalue')
          @user.reload
          expect(@user.full_name).to eq 'newvalue'
        end

        it 'redirects to users index' do
          patch :update, id: @user, user: attributes_for(:user)
          expect(response).to redirect_to users_path
        end

        context 'AJAX request' do
          before :each do
            xhr :patch, :update, id: @user, user: attributes_for(:user, full_name: 'newvalue')
          end

          it 'changes users attributes' do
            @user.reload
            expect(@user.full_name).to eq 'newvalue'
          end

          it 'does not redirect to users index' do
            expect(response).to_not redirect_to users_path
          end

          it 'responds with success' do
            expect(JSON.parse(response.body)['success']).to eq true
          end
        end

      end

      context 'with invalid attributes' do
        it 'does not change users attributes' do
          full_name = @user.full_name
          patch :update, id: @user, user: attributes_for(:user, full_name: nil)
          @user.reload
          expect(@user.full_name).to eq full_name
        end

        it 're-renders the edit template' do
          patch :update, id: @user, user: attributes_for(:invalid_user)
          expect(response).to render_template :edit
        end

        context 'AJAX request' do
          before :each do
            xhr :patch, :update, id: @user, user: attributes_for(:user, full_name: nil)
          end
          it 'does not change users attributes' do
            @user.reload
            expect(@user.full_name).to eq @user.full_name
          end

          it 'responds with 422 status code' do
            expect(response.code).to eq '422'
          end

          it 'responds with errors' do
            expect(JSON.parse(response.body)['errors']).to be_a_kind_of(Array)
          end
        end

      end
    end

    describe 'DELETE destroy' do
      before :each do
        request.env['HTTP_REFERER'] = users_path
        @user = FactoryGirl.create(:user)
      end

      it 'deletes the user' do
        expect { delete :destroy, id: @user }.to change(User, :count).by(-1)
      end

      it 'redirects to users index' do
        delete :destroy, id: @user
        expect(response).to redirect_to request.env['HTTP_REFERER']
      end
    end

  end
end
