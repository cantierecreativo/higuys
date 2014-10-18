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

  $(".js-invite").click (e) ->
    $(".js-invite-dialog").addClass('is-active')
    $(".js-invite-dialog").find("input").select()
    $(".js-invite-dialog").click (e) ->
      if $(e.target).parents('.dialog__frame').length == 0
        $(".js-invite-dialog").removeClass('is-active')

    e.preventDefault()

