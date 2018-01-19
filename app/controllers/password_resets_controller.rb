class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash_info"
      redirect_to root_url
    else
      flash.now[:danger] = t ".flash_danger"
      render "new"
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".empty")
      render "edit"
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t ".flash_success"
      redirect_to @user
    else
      render "edit"
    end
  end

  private
  def user_params
      params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    flass[:danger] = t ".not_found"
    redirect_to root_path
  end

  def valid_user
    unless (@user && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
      flass[:danger] = t ".invalid"
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t ".flash_expired"
      redirect_to new_password_reset_path
    end
  end
end
