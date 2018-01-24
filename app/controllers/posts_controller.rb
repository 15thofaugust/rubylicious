class PostsController < ApplicationController
  def create
    @post = current_user.post.build post_params
    if @post.save
      flash[:success] = t "post_success"
      redirect_to :feed
    else
      flash[:success] = t "post_failed"
      redirect_to :feed
    end
  end

  def new

  end

  def destroy

  end

  private

  def post_params
    params.require(:post).permit(:caption,:image)
  end
end

