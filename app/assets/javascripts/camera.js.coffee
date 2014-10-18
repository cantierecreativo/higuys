class @Camera
  constructor: (input: @$video, output: @$canvas, pic: @$pic) ->
    @video = @$video.get(0)
    @canvas = @$canvas.get(0)
    @con = @canvas.getContext('2d')
    @w = 600
    @h = 420
    @is_streaming = false
    @quality = .7

    @_activateVideo()
    @_activateCanvas()

  _activateCanvas: ->
    @$video.on 'canplay', (e) =>
      if not @is_streaming
        if @video.videoWidth > 0
          @h = @video.videoHeight / (@video.videoWidth / @w)
        @canvas.setAttribute('width', @w)
        @canvas.setAttribute('height', @h)
        # Reverse the canvas image
        @con.translate(@w, 0)
        @con.scale(-1, 1)
        isStreaming = true
    @$video.on 'play', (e) =>
      # Every 33 milliseconds copy the video image to the canvas
      setInterval( =>
        return if (@video.paused or @video.ended)
        @con.fillRect(0, 0, @w, @h)
        @con.drawImage(@video, 0, 0, @w, @h)
      , 33)

  _activateVideo: ->
    navigator.getUserMedia = navigator.getUserMedia or
      navigator.webkitGetUserMedia or
      navigator.mozGetUserMedia or
      navigator.msGetUserMedia
    if navigator.getUserMedia
      navigator.getUserMedia(
        video: true
        audio: false
        , (stream) =>
          url = window.URL or window.webkitURL
          @video.src = if url then url.createObjectURL(stream) else stream
          @video.play()
        , (error) =>
          alert "Fuckin error! (code: #{error.code})"
      )
    else
      alert "Sorry, the browser you are using sucks :("

  shot: ->
    data_url = @canvas.toDataURL('image/jpeg', @quality)
    @_animateShot(data_url)
    $.post("/api/upload-requests", (data) =>
      s3_url = data.url
      @_upload(data_url, s3_url)
    , 'json')

  _upload: (data_url, s3_url) ->
    blob = @_dataURItoBlob(data_url)
    $.ajax
      url: s3_url
      type: 'PUT'
      data: blob
      processData: false
      contentType: false

  _animateShot: (img) ->
    @$pic.css('backgroundImage', "url(#{img})")
    $('.camera__flash').removeClass('animate')
    $('.camera__flash').get(0).offsetWidth = $('.camera__flash').get(0).offsetWidth
    $('.camera__flash').addClass('animate')

  _dataURItoBlob: (dataURI) ->
    # convert base64/URLEncoded data component to raw binary data held in a string
    byteString = undefined
    if dataURI.split(",")[0].indexOf("base64") >= 0
      byteString = atob(dataURI.split(",")[1])
    else
      byteString = unescape(dataURI.split(",")[1])
    # separate out the mime component
    mimeString = dataURI.split(",")[0].split(":")[1].split(";")[0]
    # write the bytes of the string to a typed array
    ia = new Uint8Array(byteString.length)
    i = 0
    while i < byteString.length
      ia[i] = byteString.charCodeAt(i)
      i++
    new Blob([ia],
      type: mimeString
    )


$ ->
  camera = new Camera
    input: $('[data-camera-in]')
    output: $('[data-camera-out]')
    pic: $('[data-camera-pic]')

  $('[data-camera-shot]').click (e) ->
    console.log 'click!'
    camera.shot()
    e.preventDefault()
