class AdminsController < ApplicationController
  before_action :admin_auth
  before_action :find_user, only: [:unban,:ban,:promote,:disrank]
  def index
    @all_users = User.get_all_users
  end

  def ban
    if @user.update_attribute(:is_active, 0)
      redirect_to admins_path
      flash[:success] = t "user_banned"
    else
      redirect_to admins_path
      flash[:success] = t "cannot_ban"
    end
  end

  def unban
    if @user.update_attribute(:is_active, 1)
      redirect_to admins_path
      flash[:success] = t "user_unbanned"
    else
      redirect_to admins_path
      flash[:success] = t "cannot_unban"
    end
  end

  def promote
    if @user.update_attribute(:permission, 1)
      redirect_to admins_path
      flash[:success] = t "user_promoted"
    else
      redirect_to admins_path
      flash[:success] = t "cannot_promoted"
    end
  end

  def disrank
    if @user.update_attribute(:permission, 0)
      redirect_to admins_path
      flash[:success] = t "user_disranked"
    else
      redirect_to admins_path
      flash[:success] = t "cannot_disranked"
    end
  end
  private

  def admin_auth
    unless is_admin?
      redirect_to root_path
      flash[:danger] = t "no_permission"
    end
  end

  def find_user
    @user = User.find_by_id params[:id]
    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def ban_params
    params.require(:user).permit :is_active
  end

end
