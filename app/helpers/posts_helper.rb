module PostsHelper
  def like_count post
    "<strong class='stat likes-count-" + post.id.to_s + "'>" + post.likes.count.to_s + "</strong>"
  end
end
