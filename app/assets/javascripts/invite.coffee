$ ->
  $(".js-invite").click (e) ->
    $(".js-invite-dialog").addClass('is-active')
    $(".js-invite-dialog").find("input").select()
    $(".js-invite-dialog").click (e) ->
      if $(e.target).parents('.dialog__frame').length == 0
        $(".js-invite-dialog").removeClass('is-active')
    e.preventDefault()

