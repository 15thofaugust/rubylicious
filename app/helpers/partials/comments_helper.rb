module Partials::CommentsHelper
  def is_destroyable? comment
    current_user? comment.user or current_user.post.include? comment.post
  end
end
