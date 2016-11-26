var submit_ready = function(){
  var clearTextArea = function(){
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
    var hours = dateObj.getHours()
    var minutes = dateObj.getMinutes();

    var meridiem = "AM";
    if (hours >= 12){
      meridiem = "PM";
      hours = (hours % 12);
    }

    if (hours == 0){
      hours = 12;
    }

    var newDate = month + "/" + day + "/" + year + " " + hours + ":" +
      (minutes < 10 ? '0' : '') + minutes + meridiem;

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

var checkForMessages = function(){

  var appendOtherMessage = function(message, time){
    var message_user_id = $('#message-other-user-id')[0];
    var message_user_name = $('#message-other-user-name')[0];
    var gravatar = $('#message-other-user-gravatar')[0];

    var $div1 = $("<div>", {"class": "msg-wrap"});
    var $div2 = $("<div>", {"class": "media msg"});

    var $a = $("<a>", {"class": "pull-left", "href": "#"});
    var $img = $("<img>", {"class": "gravatar", "src": gravatar.value});

    $a.append($img);

    var $div3 = $("<div>", {"class": "media-body"});
    var $small1 = $("<small>", {"class": "pull-right time"}).text(time);
    var $h5 = $("<h5>", {"class": "media-heading"}).text(message_user_name.value + " #" + message_user_id.value);
    var $small2= $("<small>", {"class": "col-lg-10 message-text"}).text(message);

    $div3.append($small1).append($h5).append($small2);
    $div2.append($a).append($div3);
    $div1.append($div2)

    $('#messages-wrap').append($div1);
  }


  setTimeout(function(){
    var other_user = $('#message-other-user-id')[0];
    var last_message_time = $('#message-last-time')[0];
    var last_message_id = $('#message-last-id')[0];

    if (other_user == undefined){

    }
    else{
      $.ajax({
        url: "/fetch_messages",
        type: 'GET',
        data: {
          other_user_id: other_user.value,
          last_message_time: last_message_time.value,
          last_message_id: last_message_id.value
        },
        success: function(response, status, xhr) {
          console.log("success");
          response.forEach(function(message) {
            console.log(message)
            last_message_time.value = message.created_at_time;
            last_message_id.value = message.id;
            appendOtherMessage(message.message, message.created_at);
          });
          setTimeout(function(){
            checkForMessages();
          },5000)
        },
        error: function(xhr, status, error) {
          console.log(xhr, status, error);
        },
      });
    }
  }, 5000);


}

$(document).on('turbolinks:load', submit_ready);
$(document).on('turbolinks:load', checkForMessages);
