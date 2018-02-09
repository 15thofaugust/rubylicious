module CommentsHelper
  def render_comment_hashtag comment
    comment.gsub(/#\w+/) {|word| link_to word, "/posts/hashtag/#{word.delete('#')}", class: "comment_hashtag"}.html_safe
  end
end
