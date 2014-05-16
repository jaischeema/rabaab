App.PlaylistController = Ember.ObjectController.extend
  needs: ['player']

  init: ->
    @_super()
    @set('model', App.Playlist.createFromLocalStorage())

  loadPlaylist: (id) -> console.log("Loaded playlist #{id}")

  enqueue: (song) ->
    @get('model').addSong(song)

  next: -> @get('model').next()
  previous: -> @get('model').previous()
  getSongForPlaying: (id) -> @get('model').getSongForPlaying(id)

  actions:
    playSong: (song_id) ->
      song = @getSongForPlaying(song_id)
      @get('controllers.player').resetCurrentModel(song) if song?

    removeSong: (song_id) ->
      @get('model').removeSong(song_id)
