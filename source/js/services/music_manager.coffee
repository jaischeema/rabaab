@MusicManagerState = Object.freeze({"inactive": 1, "waiting": 2, "playing": 3, "paused": 4 })
class MusicManager
  constructor: (@$scope) ->
    @playlist = {}
    @state = MusicManagerState.inactive
    @playlistIds = []
    @volume = 40
    @setupKeyboardListeners()
    soundManager.setup
      url: '/js/vendor/'
      flashVersion: 9
      preferFlash: true,
      onready: => @changeState(MusicManagerState.waiting)

  setupKeyboardListeners: ->
    @$scope.$on 'togglePlayPause', => @togglePlayPause()
    @$scope.$on 'next', => @next()
    @$scope.$on 'previous', => @previous()

  createSong: (id, url) ->
    self = this
    @currentSound = soundManager.createSound
      id: "sound-#{id}"
      url: url,
      autoLoad: true,
      autoPlay: true,
      onload: -> self.changeState(MusicManagerState.playing)
      whileplaying: -> self.safeApply => self.$scope.$broadcast('playPositionChanged', this.position, this.duration)
      whileloading: -> self.safeApply => self.$scope.$broadcast('loadPositionChanged', this.bytesLoaded, this.bytesTotal)
      volume: @volume

  currentState: -> @state

  changeState: (state) ->
    @state = state
    @safeApply => @$scope.$broadcast('stateChanged', state)

  enqueue: (song) ->
    song_id = "song-#{song.id}"
    unless @playlist.hasOwnProperty(song_id)
      @playlist[song_id] = song
      @playlistIds.push song_id
      @$scope.$broadcast('trackAdded', song)
      if @state == MusicManagerState.waiting and not @currentIndex?
        @currentIndex = 0
        this.createSong(song_id, song.url)
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

  currentSong: ->
    song_id = @playlistIds[@currentIndex]
    @playlist[song_id]

  songURL: (index) ->
    song_id = @playlistIds[index]
    @playlist[song_id].url

  playSongAtCurrentIndex: ->
    @currentSound.destruct()
    @createSong(@playlistIds[@currentIndex], @songURL(@currentIndex))

  safeApply: (fn) ->
    phase = @$scope.$root.$$phase
    if phase == '$apply' || phase == '$digest'
      @$scope.$eval(fn)
    else
      @$scope.$apply(fn)

app.factory 'musicManager', ['$rootScope', 'keyboardProvider', ($rootScope, keyboardProvider) -> new MusicManager($rootScope, keyboardProvider) ]