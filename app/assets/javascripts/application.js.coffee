#= require jquery
#= require jquery_ujs
#= require headroom.js/headroom
#= require headroom.js/jQuery.headroom
#= require ./manager
#= require jquery-tourbus
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

  if Modernizr.mq('(min-width: 1024px)')
    $(".js-invite").click (e) ->
      $(".js-invite-dialog").addClass('is-active')
      $(".js-invite-dialog").find("input").select()
      $(".js-invite-dialog").click (e) ->
        if $(e.target).parents('.dialog__frame').length == 0
          $(".js-invite-dialog").removeClass('is-active')

      e.preventDefault()

    $(".js-tour").tourbus({}).trigger('depart.tourbus')

