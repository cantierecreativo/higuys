class @Client
  fetchStatus: (wall_id, cb) ->
    cb(null, [
      { id: 1, photo_url: 'http://placehold.it/640x480' },
      { id: 2, photo_url: 'http://placehold.it/640x480' },
      { id: 3, photo_url: 'http://placehold.it/640x480' },
      { id: 4, photo_url: 'http://placehold.it/640x480' },
      { id: 5, photo_url: 'http://placehold.it/640x480' }
    ])

