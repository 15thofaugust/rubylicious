$(document).ready(function(){
  var form_data = new FormData();
  var number = 0;

  setTimeout(function(){
    $('.alert').fadeOut(1000);
  },5000);

  $('#post_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > '<%= Settings.upload_max_size  %>') {
      alert('<%= t (".image_size") %>');
    }
  });

  // $(".dim-upload-post").click(function(){
  //  cancel_post();
  // });

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

  $(".upload-avatar-field").change(function () {
    preview_upload(this);
  });
});

function preview_upload(input){
  if (input.files && input.files[0]){
    var reader = new FileReader();
    reader.onload = function (e) {
      $("#avatar-preview")
        .attr("src", e.target.result);
    };
    reader.readAsDataURL(input.files[0]);
  }
}
