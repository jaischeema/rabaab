App.Playlist = Em.Object.extend
  songIds: []
  songs: {}
  currentIndex: -1

  addSong: (song) ->
    if @hasSong(song)
      Ember.debug "Song is already in the playlist"
    else
      @get('songs')[song.id] = song
      @get('songIds').pushObject song.id
      @set('currentIndex', 0) if @get('songIds').length == 1

  hasSong: (song) ->
    @get('songIds').indexOf(song.id) != -1

  next: ->
    current_index = @get('currentIndex')
    if current_index != -1 and current_index < @get('songIds').length
      current_index = current_index + 1
      @set('currentIndex', current_index)
      return @get('songs')[@get('songIds')[current_index]]

  previous: ->
    current_index = @get('currentIndex')
    if current_index != -1 and current_index > 0
      current_index = current_index - 1
      @set('currentIndex', current_index)
      return @get('songs')[@get('songIds')[current_index]]
