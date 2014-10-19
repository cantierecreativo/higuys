#= require jquery
#= require jquery_ujs

#= require ./wall/manager
#= require ./headroom
#= require ./invite
#= require ./tour
#= require ./shame

navigator.getUserMedia = navigator.getUserMedia or
  navigator.webkitGetUserMedia or
  navigator.mozGetUserMedia or
  navigator.msGetUserMedia

$ ->
  $wall = $("[data-wall-id]")
  if $wall.length > 0
    if navigator.getUserMedia
      new Manager(
        true,
        $wall.data('wall-id'),
        $wall.data('guest-id'),
        $wall,
        $(".js-autoshoot")
      )
    else
      alert("WHOOPS")

  $wall = $("[data-account-id]")
  if $wall.length > 0
    if navigator.getUserMedia
      new Manager(
        false,
        $wall.data('account-id'),
        $wall.data('guest-id'),
        $wall,
        $(".js-autoshoot")
      )
    else
      alert("WHOOPS")
