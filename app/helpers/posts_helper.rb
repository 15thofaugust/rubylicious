module PostsHelper
  def like_count post
    "<strong class='stat likes-count-" + post.id.to_s + "'>" + post.likes.count.to_s + "</strong>"
  end

  def like
    current_user.like_activities.build
  end

  def unlike id
    current_user.like_activities.find_by post_id: id
  end
end
