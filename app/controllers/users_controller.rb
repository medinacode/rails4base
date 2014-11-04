class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @limit_records = 10
    @page = params[:page] ? params[:page].to_i : 1
    @search = params[:search] || ''
    @by = list_columns.include?(params[:by]) ? params[:by] : 'id'
    @dir = ['asc', 'desc'].include?(params[:dir]) ? params[:dir] : 'asc'

    @users = User.all.order("#{@by} #{@dir}")
    @users = @users.where(search_columns.dup.map { |c| "lower(#{c}) LIKE :search" }.join(' OR '),
              { search: "%#{@search.downcase}%" }) if !@search.blank?

    @num_records = @users.count

    @users = @users.limit(@limit_records).offset((@page.to_i - 1) * @limit_records)

    @num_pages = (@num_records.to_f / @limit_records.to_f).ceil

    @list_columns = list_columns
  end

  def show
    @show_columns = show_columns
    if request.xhr?
      render '_show_ajax', :layout => false
    else
      render :show
    end
  end

  def new
    @user = User.new
    if request.xhr?
      render '_form_ajax', :layout => false
    else
      render :new
    end
  end

  def edit
    if request.xhr?
      render '_form_ajax', :layout => false
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User created'
      redirect_to users_url
    elsif request.xhr?
      render json: { errors: @user.errors.full_messages }, :status => 422
    else
      render :new
    end
  end

  def update
    if request.xhr?
      if @user.update(user_params)
        flash[:success] = 'User updated'
        render json: { success: true }
      else
        render json: { errors: @user.errors.full_messages }, :status => 422
      end
    else
      if @user.update(user_params)
        flash[:success] = 'User updated'
        redirect_to users_url
      else
        render :edit
      end
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'User deleted'
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
  @user = User.find(params[:id])
    end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end

  def search_columns
    column_names = User.column_names.dup
    column_names.delete('id')
    column_names.delete('password_digest')
    column_names.delete('created_at')
    column_names.delete('updated_at')
    column_names
  end

  def list_columns
    column_names = User.column_names.dup
    column_names.delete('id')
    column_names.delete('password_digest')
    column_names.delete('created_at')
    column_names.delete('updated_at')
    column_names
  end

  def show_columns
    column_names = User.column_names.dup
    column_names.delete('password_digest')
    column_names
  end

end
