App.Playlist = Em.Object.extend
  songs: []
  currentIndex: -1

  currentSong: ( ->
    @get('songs')[@get('currentIndex')]
  ).property('songs', 'currentIndex')

  currentSongID: ( ->
    @get('currentSong').id
  ).property('currentSong')

  addSong: (song) ->
    if @hasSong(song)
      Ember.debug "Song is already in the playlist"
    else
      @get('songs').pushObject song
      @set('currentIndex', 0) if @get('songs').length == 1

  songForID: (songID) ->
    for _song in @get('songs')
      return _song if _song.id == songID
    return null

  hasSong: (song) ->
    return @songForID(song.id)?

  next: ->
    current_index = @get('currentIndex')
    if current_index != -1 and current_index < @get('songs').length
      current_index = current_index + 1
      @set('currentIndex', current_index)
      return @get('songs')[current_index]

  previous: ->
    current_index = @get('currentIndex')
    if current_index != -1 and current_index > 0
      current_index = current_index - 1
      @set('currentIndex', current_index)
      return @get('songs')[current_index]
