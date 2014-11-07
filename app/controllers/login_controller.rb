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

  def join
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin = false
    if @user.save
      session[:user_id] = @user.id
      redirect_to :home
    else
      render :join
    end
  end

  def user_params
    params.require(:user).permit(:full_name, :nickname, :email_address, :password, :password_confirmation)
  end

end
