class ApplicationController < ActionController::Base
  before_action :get_all_users
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def get_all_users
    @user_tags = User.get_all_users
  end

  def load_post post_id
    @post = Post.find_by_id post_id
    return if @post
    flash[:danger] = t "post_not_found"
    redirect_to root_path
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = t ".log_req"
      redirect_to login_path
    end
  end
end
