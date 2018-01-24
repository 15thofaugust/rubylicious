class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:session].present?
      user = User.find_by email: params[:session][:login]
      if user && user.authenticate(params[:session][:password])
        log_in user
        remember user
        redirect_to edit_user_path user
      else
        user = User.find_by username: params[:session][:login]
        if user && user.authenticate(params[:session][:password])
          log_in user
          remember user
          redirect_to edit_user_path user
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
        redirect_to edit_user_path user
      end
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
