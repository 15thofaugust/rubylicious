class PagesController < ApplicationController
  def index
      @feed = Post.select(:id,:user_id,:image,:caption,:created_at)
      @post = current_user.post.build if logged_in?
      @user_tags = User.select(:id,:username,:avatar).order(username: :asc)
  end
end
