class PostsController < ApplicationController
  before_action only: [:show] do load_post params[:id]
  end
  before_action :correct_post, only: [:destroy, :edit, :update]
  before_action :check_ban, only: [:update, :create]
  def index
    if logged_in?
      @users = User.suggestion_users current_user.id
      show_new_feed
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
    show_new_feed
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @post = Post.new
    @post_photo = @post.photos.build
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      params[:photos][:image].each do |a|
        @post.photos.create!(image: a)
      end
      respond_to do |format|
        format.html
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
      flash[:success] = t "post_failed"
    end
    respond_to do |format|
      format.html {redirect_to root_path}
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @post.update_attributes update_post_params
      respond_to do |format|
        format.html
        format.js {flash.now[:success] = t ".post_update_success"}
      end
    else
      respond_to do |format|
        format.html
        format.js {flash.now[:danger] = t ".post_update_failed"}
      end
    end
  end

  def destroy
    if @post.destroy
      respond_to do |format|
        format.html
        format.js {flash.now[:success] = is_admin? ? @post.user.username + t("admin_delete_success") : t("post_delete_success")}
      end
    else
      respond_to do |format|
        format.html
        format.js {flash.now[:danger] = is_admin? ? @post.user.username + t("admin_delete_failed") : t("post_delete_failed")}
      end
    end
  end

  def hashtags
    tag = Hashtag.find_by(content: params[:name])
    if tag.nil?
      flash[:danger] = t "hashtag_not_found", hashtag: params[:name]
      redirect_to root_path
    else
      @posts_hashtag = tag.post_hashtag
      if @posts_hashtag.nil?
        flash[:danger] = t "hashtag_not_found", hashtag: params[:name]
        redirect_to root_path
      else
        @posts = Array.new
        @posts_hashtag.each do |post_hashtag|
          @posts << post_hashtag.post
        end
        @posts.sort! {|a, b| b.created_at <=> a.created_at}
      end
    end
  end

  private

  def update_post_params
    params.require(:post).permit(:caption)
  end

  def correct_post
    if is_admin?
      @post = Post.find_by id: params[:id]
    else
      @post = current_user.posts.find_by id: params[:id]
    end
    redirect_to root_url if @post.nil?
  end
  def post_params
    params.require(:post).permit(:user_id,
     :caption,
      photos_attributes: [:id, :post_id, :image])
  end

  def show_new_feed
    if is_admin?
        @posts = Post.get_all_posts
          .paginate page: params[:page], per_page: Settings.index_paginate_per
      else
        @posts = Post.posts_by_follower(current_user.id)
          .paginate page: params[:page], per_page: Settings.index_paginate_per
      end
  end

  def check_ban
    if is_ban?
      redirect_to root_path
      flash[:danger] = t "banned"
    end
  end
end

