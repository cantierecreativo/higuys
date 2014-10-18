#= require jquery
#= require jquery_ujs
#= require ./manager

navigator.getUserMedia = navigator.getUserMedia or
  navigator.webkitGetUserMedia or
  navigator.mozGetUserMedia or
  navigator.msGetUserMedia

$ ->
  $wall = $("[data-wall-id]")
  if $wall.length > 0
    if navigator.getUserMedia
      new Manager($wall.data('wall-id'), $wall, $(".js-autoshoot"))
    else
      alert("WHOOPS")

