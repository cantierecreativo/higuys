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

  $statusUpdate = $("[data-guest-status-url]")
  if $statusUpdate.length > 0
    new StatusUpdater($statusUpdate)

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

  if Modernizr.mq('(min-width: 1024px)')
    $(".js-invite").click (e) ->
      $(".js-invite-dialog").addClass('is-active')
      $(".js-invite-dialog").find("input").select()
      $(".js-invite-dialog").click (e) ->
        if $(e.target).parents('.dialog__frame').length == 0
          $(".js-invite-dialog").removeClass('is-active')

      e.preventDefault()

    $(".js-tour").tourbus({}).trigger('depart.tourbus')
