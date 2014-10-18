#= require ./event_emitter

class @MyView extends EventEmitter
  CAMERA_WIDTH = 640
  CAMERA_HEIGHT = 480
  JPEG_QUALITY = .7

  constructor: (@$dom) ->
    super
    @video = @$dom.find("video").get(0)
    @canvas = @$dom.find("canvas").get(0)
    @shoot = @$dom.find(".js-shoot")
    @toggleVideo(false)

    @shoot.on 'click', => @emit 'requestShoot'

  startStream: (cb) ->
    error = (e) ->
      cb(e)

    success = (stream) =>
      @stream = stream
      url = window.URL or window.webkitURL
      @video.src = if url then url.createObjectURL(stream) else stream
      @video.play()

      @video.addEventListener 'canplay', (e) =>
        streamReady = => cb()
        setTimeout(streamReady, 150)

    navigator.getUserMedia({ video: true, audio: false }, success, error)

  shootPhoto: (cb) ->
    canvas = $("<canvas/>").get(0)
    canvas.setAttribute('width', CAMERA_WIDTH)
    canvas.setAttribute('height', CAMERA_HEIGHT)

    context = canvas.getContext('2d')
    context.fillRect(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)
    context.drawImage(@video, 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)

    data = canvas.toDataURL('image/jpeg', 0.7)
    @setPhoto(data)

    data

  toggleVideo: (visible) ->
    @$dom.toggleClass('is-stream-active', visible)

  setPhoto: (url) ->
    @$dom.css(backgroundImage: "url(#{url})")

