#= require ./wall
#= require ./autoshoot_control
#= require ./client

#   ascoltare pusher
#     -> aggiornare lo stato della camera
#     -> aggiornare gli shots

#   settare i timout per l'autoshoot

class @Manager
  constructor: (@wallId, $wallDom, $autoshootControlDom) ->
    @wall = new Wall($wallDom)
    @myView = @wall.myView
    @autoshoot = new AutoshootControl($autoshootControlDom)
    @client = new Client()

    pusher = new Pusher('7217b3c3ef1446696bf5')
    @channel = pusher.subscribe("demo-#{wallId}")

    @channel.bind 'join', =>
      console.log 'JOIN'

    @channel.bind 'leave', =>
      console.log 'LEAVE'

    @channel.bind 'photo', =>
      console.log 'PHOTO'

    @autoshoot.on 'requestStateChange', (state) =>
      if state == 'COUNTDOWN'
        @restartCountdown()
      else if state == 'PAUSED'
        clearTimeout(@countdownTimeout)
        @autoshoot.setState('PAUSED')

    @refreshStatus (err) =>
      if err
        alert "Fail"
      else
        @restartCountdown()

  refreshStatus: (cb) ->
    @client.fetchStatus @wallId, (err, result) =>
      if err
        cb(err)
      else
        @wall.refreshFriends(result)
        cb()

  restartCountdown: ->
    @remainingSeconds = 3
    @autoshoot.setState('COUNTDOWN')

    shoot = =>
      photoDataUrl = @wall.myView.shootPhoto()
      @notifyNewPhoto(photoDataUrl)
      @restartCountdown()

    update = =>
      @remainingSeconds -= 1

      if @remainingSeconds == 0
        @autoshoot.setState('SHOOTING')
        @wall.myView.enableVideoStream (err) ->
          if err
            alert "FUCKSHIT"
          else
            setTimeout(shoot, 3000)
      else
        @autoshoot.setRemainingSeconds(@remainingSeconds)
        @countdownTimeout = setTimeout(update, 1000)

    update()

  notifyNewPhoto: (photoDataUrl) ->
    upload = (data) =>
      $.ajax(
        url: data.url
        type: 'PUT'
        data: @dataUriToBlob(photoDataUrl)
        processData: false
        contentType: false
      )
    $.post("/api/upload-requests", upload, 'json')

  dataUriToBlob: (dataUrl) ->
    byteString = undefined
    if dataUrl.split(",")[0].indexOf("base64") >= 0
      byteString = atob(dataUrl.split(",")[1])
    else
      byteString = unescape(dataUrl.split(",")[1])
    mimeString = dataUrl.split(",")[0].split(":")[1].split(";")[0]
    ia = new Uint8Array(byteString.length)
    i = 0
    while i < byteString.length
      ia[i] = byteString.charCodeAt(i)
      i++
    new Blob([ia], type: mimeString)

