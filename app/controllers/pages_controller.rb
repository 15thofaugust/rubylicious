class PagesController < ApplicationController
  def index
    @user_tags = User.get_all_users
    @hashtags = Hashtag.get_all_hashtags
    @feed = Post.get_all_posts
    @post = Post.new
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :caption, :image)
  end
end
