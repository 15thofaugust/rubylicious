class PostsController < ApplicationController
  def index
    @posts = Post.posts_by_follower.order(created_at: :desc)
    .paginate page: params[:page], per_page: Settings.index_paginate_per
    respond_to do |format|
      format.html
      format.js
    end
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
