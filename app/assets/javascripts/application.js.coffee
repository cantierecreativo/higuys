#= require jquery
#= require jquery_ujs

#= require ./wall/manager
#= require ./headroom
#= require ./invite
#= require ./tour
#= require ./shame
#= require ./status_updater

navigator.getUserMedia = navigator.getUserMedia or
  navigator.webkitGetUserMedia or
  navigator.mozGetUserMedia or
  navigator.msGetUserMedia

$ ->
  $wall = $(".js-wall")
  if $wall.length > 0
    if navigator.getUserMedia
      new Manager(
        $wall.data('pusher-channel'),
        $wall.data('user-id'),
        $wall,
        $(".js-autoshoot")
      )
    else
      alert("Unfortunately your browser is not fully compatible with this website. Are you using Chrome or Firefox? Then try to refresh the browser!")

  $statusUpdate = $("[data-guest-status-url]")
  if $statusUpdate.length > 0
    new StatusUpdater($statusUpdate)

