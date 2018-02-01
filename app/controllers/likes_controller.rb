class LikesController < ApplicationController
  def create
    @post = Post.find_by_id params[:post_id]
    current_user.like @post
    respond_to do |format|
      format.html {redirect_to root_path}
      format.js
    end
  end

  def destroy
    @post = Like.find_by_id(params[:id]).post
    current_user.unlike @post
    respond_to do |format|
      format.html {redirect_to root_path}
      format.js
    end
  end
end
