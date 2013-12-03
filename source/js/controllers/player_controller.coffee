@PlayerState = Object.freeze
  waiting:  1
  playing:  2
  paused:   3

App.PlayerController = Ember.ObjectController.extend
  playlist:[]
  volume: 40
  currentState: PlayerState.waiting
  currentPosition: 0
  currentDuration: 0
  currentLoadPercent: 0.00

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
      "glyphicon-pause"
    else if state == PlayerState.paused
      "glyphicon-play"
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
      self = this
      soundManager.createSound
        id: "sound-#{model.id}"
        url: music_url
        autoLoad: true
        autoPlay: true
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
    else
      Ember.debug "Music URL not found"
  ).observes('model.musicURL')

  actions:
    togglePlayPause: ->
      current_state = @get('currentState')
      if current_state == PlayerState.playing
        @get('currentSound').pause()
      else if current_state == PlayerState.paused
        @get('currentSound').resume()
      else
        Ember.debug "No sound present"

    next: ->
      Ember.debug "next action"

    previous: ->
      Ember.debug "previous action"

    shuffle: ->
      Ember.debug "shuffle action"

    repeat: ->
      Ember.debug "repeat action"
