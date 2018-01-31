class RelationshipsController < ApplicationController
  before_action :logged_in_user
  def create
    @user = User.find_by_id params[:followed_id]
    current_user.follow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by_id(params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  private
  def logged_in_user
    unless logged_in?
      flash[:danger] = t ".log_req"
      redirect_to login_path
    end
  end
end
