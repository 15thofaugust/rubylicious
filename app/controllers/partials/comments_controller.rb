class Partials::CommentsController < Partials::BaseController
  before_action :find_post, only: [:index, :create, :destroy]

  def create
    @comment = @post.comments.build comment_params
    @comment.user_id = current_user.id

    if @comment.save
      flash[:success] = t ".comment_success"
      redirect_to partials_post_comments_path
    else
      flash[:success] = t ".comment_failed"
      render root_path
    end
  end

  def index
    @comment = Comment.new
    @user_tags = User.get_all_users
    @hashtags = Hashtag.get_all_hashtags
  end

  def destroy
    if is_current_user_commnent?
      @comment.delete
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_post
    @post = Post.find_by_id(params[:post_id])
    return if @post
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def is_current_user_commnent?
    @comment = @post.comments.find_by_id(params[:id])
    @comment.user_id == current_user.id
  end
end
