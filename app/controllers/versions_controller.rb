class VersionsController < ApplicationController
  before_action :logged_in_user
  def index
    @versions = PaperTrail::Version.where("whodunnit", current_user.id)
      .order(created_at: :desc)
  end
end
