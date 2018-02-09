class FollowRequestsController < ApplicationController
  before_action :logged_in_user
  before_action :load_request, only: [:accept, :decline]

  def index
    @requests = current_user.receive_requests.order(created_at: :desc)
      .paginate page: params[:page], per_page: Settings.frequest_paginate_per
  end

  def create
    @user = User.find_by_id params[:followed_id]
    if current_user.send_follow_request.create followed_id: @user.id
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
        format.html
        format.js {flash.now[:success] = t(".destroy_success", user: @user.username)}
      end
    else
      flash[:danger] = t ".destroy_failed"
      redirect_to @user
    end
  end

  def accept
    if @received_req.destroy
      @follower = @received_req.follower
      @follower.follow current_user
      respond_to do |format|
        format.html
        format.js {flash.now[:success] = t ".accept_success"}
      end
    else
      flash[:danger] = t ".accept_failed"
      redirect_to follow_requests_path
    end
  end

  def decline
    if @received_req.destroy
      respond_to do |format|
        format.html
        format.js {flash.now[:success] = t ".decline_success"}
      end
    else
      flash[:danger] = t ".decline_failed"
      redirect_to follow_requests_path
    end
  end

  private
  def load_request
    @received_req = Follow_Request.find_by_id(params[:id])
    return if @received_req
    flash[:danger] = t ".request_not_found"
    redirect_to follow_requests_path
  end
end
