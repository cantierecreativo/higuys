#= require jquery
#= require jquery_ujs
#= require ./manager
#= require jquery-tourbus

navigator.getUserMedia = navigator.getUserMedia or
  navigator.webkitGetUserMedia or
  navigator.mozGetUserMedia or
  navigator.msGetUserMedia

$ ->
  $wall = $("[data-wall-id]")
  guestId = $("[data-guest-id]").data('guest-id')

  if $wall.length > 0
    if navigator.getUserMedia
      new Manager($wall.data('wall-id'), $wall, $(".js-autoshoot"), guestId)
    else
      alert("WHOOPS")

  $(".js-invite").click (e) ->
    $(".js-invite-dialog").addClass('is-active')
    $(".js-invite-dialog").find("input").select()
    $(".js-invite-dialog").click (e) ->
      if $(e.target).parents('.dialog__frame').length == 0
        $(".js-invite-dialog").removeClass('is-active')

    e.preventDefault()

  $(".js-tour").tourbus({}).trigger('depart.tourbus')

