class @Client
  fetchStatus: (wall_id, cb) ->
    $.get "/api/status/#{wall_id}", (data) ->
      cb(null, data)
