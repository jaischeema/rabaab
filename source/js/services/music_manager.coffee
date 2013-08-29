class MusicManager
  constructor: ->
    a = audiojs.createAll()
    @audio = a[0]
    @playlist = []

  enqueue: (song) ->
    @playlist.push song
    @audio.load(song.low_quality)
    @audio.play()

app.service 'musicManager', MusicManager