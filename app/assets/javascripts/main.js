$(document).ready(function(){
  setTimeout(function(){
    $(".alert").fadeOut(1000);
  },3000);

  var $container = $('.user-page-main-wrapper');
  $container.masonry({
    itemSelector: '.user-post',
    columnWidth: function( containerWidth ) {
      return containerWidth / 3;
    }
  });
  var cancel = false;
  $(".user-post-image").each(function(){
    var id = $(this).attr('value');
    $(this).closest('.user-post').hover(function(){
      $(".user-post-stat-" + id).css("display","flex");
    },function(){
      if(!cancel)
        $(".user-post-stat-" + id).css("display","none");
    });
  });
});
