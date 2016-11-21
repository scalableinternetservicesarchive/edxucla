var submit_ready = function(){
  var clearTextArea = function(){
    $('#message').val('');
  }

  $('#message-submit').on("click", function() {
    var message_user = $(this).parent().find('.send-message')
    var message = $(this).parent().find('.message-user')
    console.log("check1");
    $.ajax({
            success: function( response ) {
              clearTextArea();
            }
    });
  })
}

$(document).on('turbolinks:load', submit_ready);
