var submit_ready = function(){
  var clearTextArea = function(){
    console.log("clear");
    $('#send-message').val('');
  }

  var appendMessage = function(){
    var message_user_id = $('#message-user-id')[0];
    var message_user_name = $('#message-user-name')[0];
    var gravatar = $('#message-user-gravatar')[0];
    var message = $('#send-message')[0];

    var dateObj = new Date();
    var month = dateObj.getUTCMonth() + 1;
    var day = dateObj.getUTCDate();
    var year = dateObj.getUTCFullYear();
    var hours = dateObj.getUTCHours();
    var minutes = dateObj.getUTCMinutes();
    var seconds = dateObj.getUTCSeconds();

    var newDate = year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;

    var $div1 = $("<div>", {"class": "msg-wrap"});
    var $div2 = $("<div>", {"class": "media msg"});

    var $a = $("<a>", {"class": "pull-left", "href": "#"});
    var $img = $("<img>", {"class": "gravatar", "src": gravatar.value});

    $a.append($img);

    var $div3 = $("<div>", {"class": "media-body"});
    var $small1 = $("<small>", {"class": "pull-right time"}).text(newDate);
    var $h5 = $("<h5>", {"class": "media-heading"}).text(message_user_name.value + " #" + message_user_id.value);
    var $small2= $("<small>", {"class": "col-lg-10 message-text"}).text(message.value);

    $div3.append($small1).append($h5).append($small2);
    $div2.append($a).append($div3);
    $div1.append($div2)

    $('#messages-wrap').append($div1);
  }

  $('#message-submit').on("click", function() {
    $.ajax({
            success: function( response ) {
              appendMessage();
              clearTextArea();
            }
    });
  })
}

$(document).on('turbolinks:load', submit_ready);
