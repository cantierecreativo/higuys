class @StatusUpdater
  constructor: (@$dom) ->
    @updateUrl = @$dom.data('guest-status-url')
    @$dom.bind 'keypress', (e) =>
      if e.keyCode == 13
        $.ajax
          url: @updateUrl,
          type: 'PUT',
          status_message: @$dom.val()
          processData: false
          contentType: false
          success: =>
            @$dom.blur()
