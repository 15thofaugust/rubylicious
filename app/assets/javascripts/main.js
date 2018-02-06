$(document).ready(function(){
  var form_data = new FormData();
  var number = 0;

  setTimeout(function(){
    $('.alert').fadeOut(1000);
  },3000);

  $('#post_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > '<%= Settings.upload_max_size  %>') {
      alert('<%= t (".image_size") %>');
    }
  });

  $(".dim-upload-post").click(function(){
   cancel_post();
  });

  $(document).on('change','#upload-btn',function(){
    console.log($('#upload-btn').prop('files').length);
    len_files = $('#upload-btn').prop('files').length;
    for (var i = 0; i < len_files; i++) {
      var file_data = $('#upload-btn').prop('files')[i];
      form_data.append(file_data.name, file_data);
      number++;
      var construc = '<img class="preview_imgs" src="' +  window.URL.createObjectURL(file_data) + '" alt="'  +  file_data.name  + '" />';
      $('.preview-box').append(construc);
    }

    for (var pair of form_data.entries()) {
      console.log(pair[0]+ ', ' + pair[1]);
    }
  });

  // $(document).on('click','.preview_imgs',function(){
  //   var filename = $(this).attr('alt');
  //   var newfilename = filename.replace(/\./gi, "_");
  //   form_data.delete(filename);

  //   $(this).remove();

  //   for (var pair of form_data.entries()) {
  //     console.log(pair[0]+ ', ' + pair[1]);
  //   }
  // });
});
