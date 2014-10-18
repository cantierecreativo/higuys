class @Camera
  constructor: (@$video, @$canvas) ->
    @video = @$video.get(0)
    @canvas = @$canvas.get(0)
    @con = @canvas.getContext('2d')
    @w = 600
    @h = 420
    @is_streaming = false

    @activateVideo()
    @activateCanvas()

  activateCanvas: ->
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

  activateVideo: ->
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
    data_url = @canvas.toDataURL('image/png')
    console.log 'data_url', data_url
    # form_data = new FormData()
    # blob = dataURItoBlob(data_url)
    # form_data.append('file', blob)

$ ->
  camera = new Camera($('[data-camera-in]'), $('[data-camera-out]'))

  $('[data-camera-shot]').click (e) ->
    console.log 'click!'
    camera.shot()
    e.preventDefault()
