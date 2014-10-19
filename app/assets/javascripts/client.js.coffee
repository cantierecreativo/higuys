class @Client
  fetchStatus: (wallId, cb) ->
    $.get "/api/walls/#{wallId}/status", (data) ->
      cb(null, data)

  requestUpload: (wallId, cb) ->
    handler = (data) -> cb(null, data)
    $.post("/api/walls/#{wallId}/upload-requests", handler, 'json')

  notifyPhotoUpload: (wallId, s3_url, cb) ->
    $.post("/api/walls/#{wallId}/photos", s3_url: s3_url)

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

