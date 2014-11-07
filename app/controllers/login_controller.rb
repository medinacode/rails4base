class LoginController < ApplicationController
  def index
  end

  def do
    user = User.find_by_email_address(params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to :home
    else
      flash[:auth] = 'Login Failed'
      redirect_to login_path
    end
  end

  def logout
    reset_session
    redirect_to login_path
  end

end
