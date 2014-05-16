@PlayerState = Object.freeze
  waiting:  1
  playing:  2
  paused:   3

App.PlayerController = Ember.ObjectController.extend
  needs: ['playlist']
  volume: 40
  currentState: PlayerState.waiting
  currentPosition: 0
  currentDuration: 0
  currentLoadPercent: 0.00
  playlist: Ember.computed.alias("controllers.playlist")

  isPlaying: ( ->
    state = @get('currentState')
    state == PlayerState.playing or state == PlayerState.paused
  ).property('currentState')

  playProgressWidth: ( ->
    percent = ( @get('currentPosition') / @get('currentDuration') ) * 100
    "width: #{percent}%"
  ).property('currentPosition', 'currentDuration')

  downloadProgressWidth: ( ->
    "width: #{@get('currentLoadPercent')}%"
  ).property('currentLoadPercent')

  playButtonClass: ( ->
    state = @get('currentState')
    if state == PlayerState.playing
      "icon-pause"
    else if state == PlayerState.paused
      "icon-play"
  ).property('currentState')

  enqueue: (song) ->
    songObj = App.Song.create(song)
    @get('playlist').enqueue(songObj)
    @resetCurrentModel(songObj) unless @get('model')?

  musicURLFetchedForModel: ( ->
    model = @get('model')
    music_url = model.get('musicURL')
    if music_url?
      self = this
      soundManager.createSound(
        id: "sound-#{model.id}"
        url: music_url
        autoLoad: true
        onplay: ->
          self.set('currentSound', this)
          self.set('currentState', PlayerState.playing)
        onresume: -> self.set('currentState', PlayerState.playing)
        onpause: -> self.set('currentState', PlayerState.paused)
        whileplaying: ->
          self.set('currentPosition', this.position)
          self.set('currentDuration', this.duration)
        whileloading: ->
          self.set('currentLoadPercent', (this.bytesLoaded/this.bytesTotal) * 100)
        onfinish: -> self.send('next')
        volume: self.get('volume')
      ).play()
    else
      Ember.debug "Music URL not found"
  ).observes('model.musicURL')

  resetCurrentModel: (song) ->
    if song?
      currentSound = @get('currentSound')
      currentSound.destruct() if currentSound?
      @set('currentPosition', 0)
      @set('currentDuration', 0)
      @set('currentLoadPercent', 0.00)
      @set('model', song)
      song.refresh() unless song.get('isPlayable')

  actions:
    togglePlayPause: ->
      current_state = @get('currentState')
      if current_state == PlayerState.playing
        @get('currentSound').pause()
      else if current_state == PlayerState.paused
        @get('currentSound').resume()
      else
        Ember.debug "No sound present"

    playSong: (song_id) ->
      song = @get('playlist').getSongForPlaying(song_id)
      @resetCurrentModel(song) if song?

    next: ->
      next_song = @get('playlist').next()
      @resetCurrentModel(next_song)

    previous: ->
      previous_song = @get('playlist').previous()
      @resetCurrentModel(previous_song)

    shuffle: ->
      Ember.debug "shuffle action"

    repeat: ->
      Ember.debug "repeat action"
