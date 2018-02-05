class NotificationsController < ApplicationController
  after_action :seen, only: :index

  def index
    @notifications = current_user.passive_notifications
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 5)
  end

  def seen
    current_user.seen_all
  end
end
