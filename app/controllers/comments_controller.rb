class CommentsController < ApplicationController
  def index
    @comments = Comment.comments_by_posts(params[:id], params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create

  end

  def destroy

  end
end
