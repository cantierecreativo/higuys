class @StatusUpdater
  constructor: ($dom) ->
    updateUrl = $dom.data('guest-status-url')
    $dom.bind 'keypress', (e) ->
      if e.keyCode == 13
        $('.js-my-status-message').text($dom.val())
        $.ajax
          url: updateUrl,
          type: 'PUT',
          data: {status_message: $dom.val()}
          success: ->
            $dom.blur()
            $dom.val('')
