class ApplicationController < ActionController::Base
  before_action :get_all_users
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def get_all_users
    @user_tags = User.get_all_users
  end
end
