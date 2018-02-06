class CommentsController < ApplicationController
  before_action only: [:create] do find_post params[:post_id]
  end
  before_action :load_comment, only: [:destroy]

  def index
    @comments = Comment.comments_by_posts(params[:id], params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @comment = @post.comments.build comment_params
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html
        format.js {flash.now[:success] = t ".comment_success"}
      end
    else
      respond_to do |format|
        format.html
        format.js {flash.now[:danger] = t ".comment_failed"}
      end
    end
  end

  def destroy
    if @comment.delete
      respond_to do |format|
        format.html
        format.js {flash.now[:success] = t ".delete_success"}
      end
    else
      respond_to do |format|
        format.html
        format.js {flash.now[:danger] = t ".delete_failed"}
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id, :user_id)
  end

  def load_comment
    @comment = Comment.find_by_id params[:id]
    return if @comment
    flash[:danger] = t "comment_not_found"
    redirect_to root_path
  end
end
