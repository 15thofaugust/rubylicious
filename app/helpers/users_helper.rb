module UsersHelper
  def send_request
    current_user.send_follow_request.build
  end

  def cancel_request id
    current_user.send_follow_request.find_by followed_id: id
  end

  def update_request id
    current_user.receive_follow_request.find_by follower_id: id
  end
end
