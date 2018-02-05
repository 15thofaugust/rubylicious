class PostsController < ApplicationController
  before_action :find_post, only: [:show]

  def index
    if logged_in?
      @posts = Post.posts_by_follower(current_user.id)
      .paginate page: params[:page], per_page: Settings.index_paginate_per
      respond_to do |format|
        format.html
        format.js
      end
      @user_tags = User.get_all_users
      @hashtags = Hashtag.get_all_hashtags
      @post = Post.new
    else
      redirect_to login_path
    end
  end

  def show
    if logged_in?
      @current_post = Post.get_post_by_id @post.id
      @comments = Comment.get_all_post_comments @post.id
      respond_to do |format|
        format.html
        format.js
      end
    else
      redirect_to login_path
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.post.build post_params
    if @post.save
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js
      end
      pattern = /\"\/users\/(.*?)\"/
      matches = []

      @post.caption.scan(pattern) do
        matches << $1
      end
      matches.each do |res|
        if @post.user_id != Integer(res)
          Notification.create(type_noti: 3, user_set_id: @post.user_id,
            user_get_id: res, post_id: @post.id)
        end
      end

      flash[:success] = t "post_success"
    else
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js
      end
      flash[:success] = t "post_failed"
    end
  end

  def update
  end

  def destroy
  end

  private

  def find_post
    @post = Post.find_by_id(params[:post_id])
    return if @post
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def post_params
    params.require(:post).permit(:user_id, :caption, :image)
  end
end
