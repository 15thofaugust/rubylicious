$('.read-more-<%= post.id %>').on('click', function(e) {
  e.preventDefault()
  $(this).parent().html('<p><%= escape_javascript post.caption %></p>')
})
