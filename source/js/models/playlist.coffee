PLAYLIST_SONGS_PATH = 'rabaab.playlist.songs'
PLAYLIST_CURRENT_INDEX = 'rabaab.playlist.index'

App.Playlist = Em.Object.extend
  songs: []
  currentIndex: -1
  isLocal: false

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
      @save()

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

  save: ->
    return unless @get('isLocal')
    song_attrs = []
    for _song in @get('songs')
      song_attrs.pushObject _song.toLocalHash()
    localStorage.setItem(PLAYLIST_SONGS_PATH, JSON.stringify(song_attrs))

  currentIndexChanged: ( ->
    localStorage.setItem(PLAYLIST_CURRENT_INDEX, @get('currentIndex'))
  ).observes('currentIndex')

App.Playlist.reopenClass
  createFromLocalStorage: ->
    playlist = App.Playlist.create()
    playlist.set('isLocal', true)
    song_list = localStorage.getItem(PLAYLIST_SONGS_PATH)
    if song_list?
      songs = []
      for song_attrs in JSON.parse(song_list)
        songs.pushObject App.Song.create(song_attrs)
      playlist.set('songs', songs)
    current_index = localStorage.getItem(PLAYLIST_CURRENT_INDEX)
    playlist.set('index', current_index? ? current_index : -1)
    return playlist
