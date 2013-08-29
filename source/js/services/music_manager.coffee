@MusicManagerState = Object.freeze({"inactive": 1, "waiting": 2, "playing": 3, "paused": 4 })
class MusicManager
  constructor: (@$scope) ->
    @playlist = {}
    @state = MusicManagerState.inactive
    @playlistIds = []
    @volume = 40
    soundManager.setup
      url: '/js/vendor/'
      flashVersion: 9
      preferFlash: true,
      onready: => @changeState(MusicManagerState.waiting)

  createSong: (id, url) ->
    @currentSound = soundManager.createSound
      id: "sound-#{id}"
      url: url,
      autoLoad: true,
      autoPlay: true,
      onload: => @changeState(MusicManagerState.playing)
      volume: @volume

  currentState: -> @state

  changeState: (state) ->
    @state = state
    @$scope.$broadcast('stateChanged', state)

  enqueue: (song) ->
    song_id = "song-#{song.id}"
    unless @playlist.hasOwnProperty(song_id)
      @playlist[song_id] = song
      @playlistIds.push song_id
      @$scope.$broadcast('trackAdded', song)
      if @state == MusicManagerState.waiting and not @currentIndex?
        @currentIndex = 0
        this.createSong(song_id, song.low_quality)
    else
      console.log "Already in playlist, ignored!"

  togglePlayPause: ->
    if @state == MusicManagerState.paused
      @play()
    else if @state == MusicManagerState.playing
      @pause()

  play: ->
    if @state == MusicManagerState.paused
      @currentSound.play()
      @changeState(MusicManagerState.playing)

  pause: ->
    if @state == MusicManagerState.playing
      @currentSound.pause()
      @changeState(MusicManagerState.paused)

  next: ->
    if @isInPlayableState() and ( @currentIndex < @playlistIds.length - 1 )
      @currentIndex += 1
      @playSongAtCurrentIndex()

  previous: ->
    if @isInPlayableState() and @currentIndex > 0
      @currentIndex -= 1
      @playSongAtCurrentIndex()

  playAtIndex: (index) ->
    if @isInPlayableState() and index >= 0 and index <= @playlistIds.length - 1
      @currentIndex = index
      @playSongAtCurrentIndex()

  isInPlayableState: -> @state == MusicManagerState.playing or @state == MusicManagerState.paused

  songURL: (index) ->
    song_id = @playlistIds[index]
    @playlist[song_id].low_quality

  playSongAtCurrentIndex: ->
    @currentSound.destruct()
    @createSong(@playlistIds[@currentIndex], @songURL(@currentIndex))

app.factory 'musicManager', ($rootScope) -> new MusicManager($rootScope)