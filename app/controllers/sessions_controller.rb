class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    if params[:session].present?
      user = User.find_by email: params[:session][:login]
      if user && user.authenticate(params[:session][:password])
        log_in user
        remember user
        redirect_to root_path
      else
        user = User.find_by username: params[:session][:login]
        if user && user.authenticate(params[:session][:password])
          log_in user
          remember user
          redirect_to root_path
        else
          flash.now[:danger] = t ".wrong_combination"
          render :new
        end
      end
    else
      begin
        user = User.from_omniauth(request.env["omniauth.auth"])
        session[:user_id] = user.id
        remember user
        redirect_to root_path
      end
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
