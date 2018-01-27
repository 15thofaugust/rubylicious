class PostsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.post.build post_params
    if @post.save
      flash[:success] = "ok" #t "post_success"
      redirect_to root_path
    else
      flash[:success] = "failed" #t "post_failed"
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
