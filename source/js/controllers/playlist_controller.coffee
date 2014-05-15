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
  songForID: (id) -> @get('model').songForID(id)

  actions:
    playSong: (song_id) ->
      song = @songForID(song_id)
      @get('controllers.player').resetCurrentModel(song)
