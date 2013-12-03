@MusicManagerState = Object.freeze({"inactive": 1, "waiting": 2, "playing": 3, "paused": 4 })
App.PlayerController = Ember.ObjectController.extend
  playlist:[]
  currentState: MusicManagerState.inactive

  isPlaying: ( ->
    current_state = @get('currentState')
    current_state == MusicManagerState.playing or current_state == MusicManagerState.paused
  ).property('currentState')

  enqueue: (song) ->
    obj = App.Song.create(song)
    @pushObject(obj)
    if @get('model')?
      Ember.debug "Added song to playlist"
    else
      Ember.debug "Start Playing the song"
      @set('model', obj)
      obj.refresh() unless obj.get('isPlayable')

  pushObject: (song) ->
    @get('playlist').pushObject song

  musicURLFetchedForModel: ( ->
    model = @get('model')
    music_url = model.get('musicURL')
    if music_url?
      currentSound = soundManager.createSound
        id: "sound-#{model.id}"
        url: music_url
        autoLoad: true
        autoPlay: true
        onload: => @set('currentState', MusicManagerState.playing)
        whileplaying: -> self.safeApply => self.$scope.$broadcast('playPositionChanged', this.position, this.duration)
      whileloading: -> self.safeApply => self.$scope.$broadcast('loadPositionChanged', this.bytesLoaded, this.bytesTotal)
      onfinish: -> self.next()
      volume: @volume
      soundManager.createSound
        url: music_url
        autoLoad: true
        autoPlay: true
        onload: => @loadedSong()
    else
      Ember.debug "Music URL not found"
  ).observes('model.musicURL')

  createSong: (id, url) ->
    self = this

  loadedSong: ->
    @set('isPlaying', true)
