class PostsController < ApplicationController
  def index
    @posts = Post.posts_by_follower
    .paginate page: params[:page], per_page: Settings.index_paginate_per
    respond_to do |format|
      format.html
      format.js
    end
    @post = Post.new
    @user_tags = User.get_all_users
    @hashtags = Hashtag.get_all_hashtags
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.post.build post_params
    if @post.save
      flash[:success] = t "post_success"
      redirect_to root_path
    else
      flash[:danger] = t "post_failed"
      redirect_to root_path
    end
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
