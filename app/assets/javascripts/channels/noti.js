function noti(){
  if (Notification.permission === "granted") {
    var notification = new Notification("Notification title", {
      icon: "http://cdn.sstatic.net/stackexchange/img/logos/so/so-icon.png",
      body: "Hey there! You've been notified!",
    });

    notification.onclick = function () {
      window.open("https://github.com/");
    };

    setTimeout(function(){
      notification.close();
    },5000);
  } else {
    Notification.requestPermission();
  }
}
