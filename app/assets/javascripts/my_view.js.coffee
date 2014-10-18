# class MyView
#   states:
#     IDLE
#     SHOOTING

#   methods:
#     setState: (state) ->

# if @video.videoWidth > 0
#   @h = @video.videoHeight / (@video.videoWidth / CAMERA_WIDTH)
#
# @$pic.css('backgroundImage', "url(#{dataUrl})")

# $('.camera__flash').removeClass('animate')
# $('.camera__flash').get(0).offsetWidth = $('.camera__flash').get(0).offsetWidth
# $('.camera__flash').addClass('animate')

class @MyView
  CAMERA_WIDTH = 640
  CAMERA_HEIGHT = 480
  JPEG_QUALITY = .7

  constructor: (@$dom) ->
    @video = @$dom.find("video").get(0)
    @canvas = @$dom.find("canvas").get(0)
    @context = @canvas.getContext('2d')
    @shootUrl = null
    @state = ''

  enableVideoStream: (cb) ->
    error = (e) -> cb(e)

    refreshCanvas = =>
      return if (@video.paused or @video.ended)
      @context.fillRect(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)
      @context.drawImage(@video, 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)

    startedStream = (stream) =>
      url = window.URL or window.webkitURL
      @video.src = if url then url.createObjectURL(stream) else stream
      @video.play()

      @video.addEventListener 'canplay', (e) =>
        @canvas.setAttribute('width', CAMERA_WIDTH)
        @canvas.setAttribute('height', CAMERA_HEIGHT)
        @context.translate(CAMERA_WIDTH, 0)
        @context.scale(-1, 1)
        setInterval(refreshCanvas, 33)
        setTimeout(cb, 150)

    navigator.getUserMedia({ video: true, audio: false }, startedStream, error)

  shootPhoto: (cb) ->
    @canvas.toDataURL('image/jpeg', 0.7)

