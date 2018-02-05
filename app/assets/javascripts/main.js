$(document).ready(function(){
  setTimeout(function(){
    $(".alert").fadeOut(1000);
  },3000);

    $("#post_image").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > '<%= Settings.upload_max_size  %>') {
      alert('<%= t (".image_size") %>');
    }
  });
});
