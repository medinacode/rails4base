class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_user
      if session[:user_id].nil?
          flash[:message] = '<h4 class="danger">Access Denied</h4>You must log in to access that page.'
          #redirect_to login_path
      end
  end

end
