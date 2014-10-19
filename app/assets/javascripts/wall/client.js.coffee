class @Client
  constructor: ->

  fetchStatus: (cb) ->
    $.get "/api/wall", (data) ->
      cb(null, data)

  requestUpload: (cb) ->
    handler = (data) -> cb(null, data)
    $.post("/api/wall/upload-requests", handler, 'json')

  notifyPhotoUpload: (s3_url, cb) ->
    $.post("/api/wall/photos", s3_url: s3_url)

  s3Put: (url, data, cb) ->
    $.ajax(
      url: url
      type: 'PUT'
      data: data
      processData: false
      contentType: false
      success: (data) ->
        cb(null, data)
    )

