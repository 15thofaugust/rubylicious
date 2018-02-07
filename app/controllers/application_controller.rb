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
end
