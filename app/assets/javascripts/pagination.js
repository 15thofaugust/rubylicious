$(document).on('turbolinks:load', function () {
  $(window).on('scroll', function(){
    more_posts_url = $('.pagination .next_page a').attr('href');
    // if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100) {
    if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100) {
      $('.pagination').html('<img src="/assets/resources/loading.gif" alt="Loading..." title="Loading..." />');
      $.getScript(more_posts_url);
    }
  });
});

$(".dropdown-menu").on('scroll', function(){
  console.log("a");
  more_posts_url = $('.pagination .next_page a').attr('href');
  // if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100) {
  if (more_posts_url && $(window).scrollTop() > $(".dropdown-menu").height() - $("#my-notifications").height() - 100) {
    $('.pagination').html('<img src="/assets/resources/loading.gif" alt="Loading..." title="Loading..." />');
    $.getScript(more_posts_url);
  }
});

