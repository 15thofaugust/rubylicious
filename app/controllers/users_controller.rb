class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :find_user, except: [:new, :create, :finish]
  before_action :correct_user, only: [:edit, :udpate]
  before_action :admin_user, only: :destroy


  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def show
    @posts = @user.posts.order(created_at: :desc).paginate page: params[:page],
      per_page: Settings.user_post_paginate_per
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      log_in @user
      remember @user
      redirect_to @user
      flash[:success] = t ".create_success"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes update_params
      flash[:success] = t ".update_success"
      redirect_to edit_user_path
    else
      flash[:danger] = t ".update_failed"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :email,
      :fullname,
      :username,
      :password,
      :password_confirmation,
      :avatar
  end

  def update_params
    params.require(:user).permit :fullname,
      :username,
      :bio,
      :gender,
      :password,
      :password_confirmation,
      :isprivate,
      :avatar,
      :is_active
  end

  def logged_in_user
    return if logged_in?
    flash[:danger] = t ".log_req"
    redirect_to login_path
  end

  def correct_user
    return if current_user? @user
    redirect_to root_url
  end

  def admin_user
   redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by_id params[:id]
    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end
end
