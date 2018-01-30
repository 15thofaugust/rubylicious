class NotificationsController < ApplicationController
  after_action :seen, only: :index

  def index;end

  def seen
    current_user.seen_all
  end
end
