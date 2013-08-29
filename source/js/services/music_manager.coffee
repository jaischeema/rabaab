class MusicManager
  constructor: ->
    @ready = false
    @playlist = []
    soundManager.setup
      url: '/js/vendor/'
      flashVersion: 9
      preferFlash: true,
      onready: => @ready = true

  createSong: (id, url) ->
    soundManager.createSound
      id: "sound-#{id}"
      url: url,
      autoLoad: true,
      autoPlay: true,
      onload: -> console.log("loaded")
      volume: 50

  enqueue: (song) ->
    @playlist.push song
    this.createSong song.id, song.low_quality

  # play: -> @audio.play()
  # pause: -> @audio.pause()
  # next: -> console.log("play next song")

app.service 'musicManager', MusicManager