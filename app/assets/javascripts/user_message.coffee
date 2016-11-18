# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@paintIt = (element) ->
  element.attr("active-conversation", true)

$ ->
  $("a[data-active-conversation]").click (e) ->
    e.preventDefault()
    $("a[data-active-conversation").attr("data-active-conversation", true)