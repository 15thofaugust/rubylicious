class CommentsController < ApplicationController
  def index
    @comments = Comment.comments_by_posts(params[:id])
      .order(created_at: :desc).limit Settings.min_comment_load * params[:page].to_i
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
