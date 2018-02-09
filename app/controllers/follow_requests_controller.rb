class FollowRequestsController < ApplicationController
  before_action :logged_in_user
  def create
    @user = User.find_by_id params[:followed_id]
    if current_user.send_follow_request.create followed_id: @user.id, status: 0
      respond_to do |format|
        format.html {redirect_to @user}
        format.js {flash.now[:success] = t(".create_success", user: @user.username)}
      end
    else
      flash[:danger] = t ".create_failed"
      redirect_to @user
    end
  end

  def destroy
    @user = Follow_Request.find_by_id(params[:id]).followed
    if current_user.sent_requests.delete @user
      respond_to do |format|
        format.html {redirect_to @user}
        format.js {flash.now[:success] = t(".destroy_success", user: @user.username)}
      end
    else
      flash[:danger] = t ".destroy_failed"
      redirect_to @user
    end
  end
end
