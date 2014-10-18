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
      @refreshStatus()

    @channel.bind 'leave', =>
      @refreshStatus()

    @channel.bind 'photo', =>
      @refreshStatus()

    @autoshoot.on 'requestStateChange', (state) =>
      if state == 'COUNTDOWN'
        @restartCountdown()
      else if state == 'PAUSED'
        clearTimeout(@countdownTimeout)
        @countdownTimeout =  null
        @autoshoot.setState('PAUSED')

    @myView.on 'requestShoot', =>
      return if @isShooting
      return if @autoshoot.state == 'SHOOTING'

      if @autoshoot.state == 'COUNTDOWN'
        clearTimeout(@countdownTimeout)
        @countdownTimeout = null
        @shoot()

    @refreshStatus (err) =>
      @myView.startStream (e) =>
        if e
          alert "Fail"
        else
          @shoot()

  refreshStatus: (cb) ->
    @client.fetchStatus @wallId, (err, result) =>
      if err
        cb(err)
      else
        @wall.refreshFriends(result)
        cb()

  shoot: ->
    getPhoto = =>
      photoDataUrl = @wall.myView.shootPhoto()
      @wall.myView.toggleVideo(false)
      @notifyNewPhoto(photoDataUrl)
      @restartCountdown()

    @autoshoot.setState('SHOOTING')
    @wall.myView.toggleVideo(true)
    setTimeout(getPhoto, 2000)

  restartCountdown: ->
    @remainingSeconds = 20
    @autoshoot.setState('COUNTDOWN')

    update = =>
      @remainingSeconds -= 1

      if @remainingSeconds == 0
        @countdownTimeout = null
        @shoot()
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

