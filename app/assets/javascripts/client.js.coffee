class @PublicClient
  constructor: (@wallId) ->

  fetchStatus: (cb) ->
    $.get "/api/walls/#{@wallId}", (data) ->
      cb(null, data)

  requestUpload: (cb) ->
    handler = (data) -> cb(null, data)
    $.post("/api/walls/#{@wallId}/upload-requests", handler, 'json')

  notifyPhotoUpload: (s3_url, cb) ->
    $.post("/api/walls/#{@wallId}/photos", s3_url: s3_url)

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

class @PrivateClient
  constructor: (@accountId) ->

  fetchStatus: (cb) ->
    $.get "/api/accounts/#{@accountId}/status", (data) ->
      cb(null, data)

  requestUpload: (cb) ->
    handler = (data) -> cb(null, data)
    $.post("/api/accounts/#{@accountId}/upload-requests", handler, 'json')

  notifyPhotoUpload: (s3_url, cb) ->
    $.post("/api/accounts/#{@accountId}/photos", s3_url: s3_url)

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

