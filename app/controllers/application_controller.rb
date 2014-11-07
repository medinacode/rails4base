class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :is_mobile?

  def authenticate_user
      if session[:user_id].nil?
          flash[:auth] = 'Access Denied'
          redirect_to login_path
      end
  end

  def current_user
    session[:user_id] ? User.find(session[:user_id]) : nil
  end

  def user_is_admin
    unless current_user.admin?
      flash[:auth] = 'Access Denied'
      redirect_to logout_path
    end
  end

  def user_is_me_or_admin
    unless current_user.admin?
      if controller_name == 'users'
        unless @record.id == current_user.id
          flash[:auth] = 'Access Denied'
          redirect_to logout_path
        end
      else
        unless @record.user_id == current_user.id
          flash[:auth] = 'Access Denied'
          redirect_to logout_path
        end
      end
    end
  end

  def is_mobile?
    request.user_agent =~ /Mobile|webOS/
  end

end
