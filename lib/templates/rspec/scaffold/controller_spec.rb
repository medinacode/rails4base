require 'rails_helper'

<% module_namespacing do -%>
RSpec.describe <%= controller_class_name %>Controller, :type => :controller do

  describe 'GET show' do
    before :each do
      @<%= ns_file_name %> = FactoryGirl.create(:<%= ns_file_name %>)
    end

    it 'assigns the requested <%= ns_file_name %>' do
      get :show, id: @<%= ns_file_name %>
      expect(assigns(:<%= ns_file_name %>)).to eq @<%= ns_file_name %>
    end

    it 'renders the show template' do
      get :show, id: @<%= ns_file_name %>
      expect(response).to render_template :show
    end

    it 'renders the ajax template on xhr request' do
      xhr :get, :show, id: @<%= ns_file_name %>
      expect(response).to render_template :_show_ajax
    end
  end

  describe 'GET index' do
    before(:each) do
      @a = FactoryGirl.create(:<%= ns_file_name %>)
      @b = FactoryGirl.create(:<%= ns_file_name %>)
    end

    it 'assigns all <%= table_name.pluralize %>' do
      get :index
      expect(assigns(:<%= ns_file_name %>s)).to include @a, @b
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET new' do
    it 'assigns a new <%= ns_file_name %>' do
      get :new
      expect(assigns(:<%= ns_file_name %>)).to be_a_new <%= class_name %>
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
      @<%= ns_file_name %> = FactoryGirl.create(:<%= ns_file_name %>)
    end
    it 'assigns the requested <%= ns_file_name %>' do
      get :edit, id: @<%= ns_file_name %>
      expect(assigns(:<%= ns_file_name %>)).to eq @<%= ns_file_name %>
    end

    it 'renders the :edit template' do
      get :edit, id: @<%= ns_file_name %>
      expect(response).to render_template :edit
    end

    it 'renders the ajax template on xhr request' do
      xhr :get, :edit, id: @<%= ns_file_name %>
      expect(response).to render_template :_form_ajax
    end

  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'saves the new <%= ns_file_name %>' do
        expect { post :create, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>) }.to change(<%= class_name %>, :count).by 1
      end

      it 'redirects to <%= table_name.pluralize %> index' do
        post :create, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>)
        expect(response).to redirect_to <%= table_name.pluralize %>_path
      end

      context 'AJAX request' do
        it 'saves the new <%= ns_file_name %>' do
          expect { xhr :post, :create, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>) }.to change(<%= class_name %>, :count).by 1
        end

        it 'does not redirect to <%= table_name.pluralize %> index' do
          xhr :post, :create, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>)
          expect(response).to_not redirect_to <%= table_name.pluralize %>_path
        end

        it 'responds with success' do
          xhr :post, :create, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>)
          expect(JSON.parse(response.body)['success']).to eq true
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new <%= ns_file_name %>' do
        expect { post :create, <%= ns_file_name %>: attributes_for(:invalid_<%= ns_file_name %>) }.to_not change(<%= class_name %>, :count)
      end

      it 're-renders the new template' do
        post :create, <%= ns_file_name %>: attributes_for(:invalid_<%= ns_file_name %>)
        expect(response).to render_template :new
      end

      context 'AJAX request' do
        it 'does not save the new <%= ns_file_name %>' do
          expect { xhr :post, :create, <%= ns_file_name %>: attributes_for(:invalid_<%= ns_file_name %>) }.to_not change(<%= class_name %>, :count)
        end

        it 'responds with 422 status code' do
          xhr :post, :create, <%= ns_file_name %>: attributes_for(:invalid_<%= ns_file_name %>)
          expect(response.code).to eq '422'
        end

        it 'responds with errors' do
          xhr :post, :create, <%= ns_file_name %>: attributes_for(:invalid_<%= ns_file_name %>)
          expect(JSON.parse(response.body)['errors']).to be_a_kind_of(Array)
        end
      end

    end
  end

  describe 'PATCH update' do
    before :each do
      @<%= ns_file_name %> = FactoryGirl.create(:<%= ns_file_name %>)
    end

    context 'with valid attributes' do
      it 'locates the requested <%= ns_file_name %>' do
        patch :update, id: @<%= ns_file_name %>, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>)
        expect(assigns(:<%= ns_file_name %>)).to eq @<%= ns_file_name %>
      end

      it 'changes <%= table_name.pluralize %> attributes' do
        patch :update, id: @<%= ns_file_name %>, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>, <%=attributes.first.column_name %>: 'newvalue')
        @<%= ns_file_name %>.reload
        expect(@<%= ns_file_name %>.<%=attributes.first.column_name %>).to eq 'newvalue'
      end

      it 'redirects to <%= table_name.pluralize %> index' do
        patch :update, id: @<%= ns_file_name %>, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>)
        expect(response).to redirect_to <%= table_name.pluralize %>_path
      end

      context 'AJAX request' do
        before :each do
          xhr :patch, :update, id: @<%= ns_file_name %>, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>, <%=attributes.first.column_name %>: 'newvalue')
        end

        it 'changes <%= table_name.pluralize %> attributes' do
          @<%= ns_file_name %>.reload
          expect(@<%= ns_file_name %>.<%=attributes.first.column_name %>).to eq 'newvalue'
        end

        it 'does not redirect to <%= table_name.pluralize %> index' do
          expect(response).to_not redirect_to <%= table_name.pluralize %>_path
        end

        it 'responds with success' do
          expect(JSON.parse(response.body)['success']).to eq true
        end
      end

    end

    context 'with invalid attributes' do
      it 'does not change <%= table_name.pluralize %> attributes' do
        <%=attributes.first.column_name %> = @<%= ns_file_name %>.<%=attributes.first.column_name %>
        patch :update, id: @<%= ns_file_name %>, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>, <%=attributes.first.column_name %>: nil)
        @<%= ns_file_name %>.reload
        expect(@<%= ns_file_name %>.<%=attributes.first.column_name %>).to eq <%=attributes.first.column_name %>
      end

      it 're-renders the edit template' do
        patch :update, id: @<%= ns_file_name %>, <%= ns_file_name %>: attributes_for(:invalid_<%= ns_file_name %>)
        expect(response).to render_template :edit
      end

      context 'AJAX request' do
        before :each do
          xhr :patch, :update, id: @<%= ns_file_name %>, <%= ns_file_name %>: attributes_for(:<%= ns_file_name %>, <%=attributes.first.column_name %>: nil)
        end
        it 'does not change <%= table_name.pluralize %> attributes' do
          @<%= ns_file_name %>.reload
          expect(@<%= ns_file_name %>.<%=attributes.first.column_name %>).to eq @<%= ns_file_name %>.<%=attributes.first.column_name %>
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
      request.env['HTTP_REFERER'] = <%= table_name.pluralize %>_path
      @<%= ns_file_name %> = FactoryGirl.create(:<%= ns_file_name %>)
    end

    it 'deletes the <%= ns_file_name %>' do
      expect { delete :destroy, id: @<%= ns_file_name %> }.to change(<%= class_name %>, :count).by(-1)
    end

    it 'redirects to <%= table_name.pluralize %> index' do
      delete :destroy, id: @<%= ns_file_name %>
      expect(response).to redirect_to request.env['HTTP_REFERER']
    end

  end

end
<% end -%>
