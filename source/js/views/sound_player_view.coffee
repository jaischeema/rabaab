Ember.SoundPlayerView = Ember.View.extend
  init: ->
    manager = Ember.SoundPlayerManager.create()
    @set("stateManager", manager)
    soundManager.onready =>
      manager.send('ready')
      @loadSound()
    @_super()

  soundLoaded: ->
    @get('stateManager').send('loaded')
    @set('position', 0)
    @set('duration', this.get('sound').duration)

  loadSound: ->
    @stop() unless @get('isStopped')
    unless @soundObject
      @soundObject = soundManager.createSound
        url: @get('url')
        onload: => @soundLoaded()
        whileplaying: => @tick()
        onfinish: @finish()
      @soundObject.load()

  sound: ( ->
    @loadSound()
    return @soundObject
  ).property('url')

  play: ->
    if @get('isStopped')
      @get('sound').play()
    else
      @get('sound').resume()
    @get('stateManager').send('play')

  pause: ->
    @get('soundManager').send('pause')
    @get('sound').pause()

  toggle: ->
    if @get('isPlaying')
      @pause()
    else
      @play()

  stop: ->
    @get('stateManager').send('stop')
    @get('sound').stop()
    @set('position', 0)

  finish: ->
    @get('stateManager').send('stop')
    @set('position', 0)

  tick: ->
    @set('position', @get('sound').position)

  isLoading: ( ->
    return @.get('stateManager.currentState.name') == 'unloaded'
  ).property('stateManager.currentState')

  isStopped: ( ->
    return !/^started\./.test(@get('stateManager.currentState.path'))
  ).property('stateManager.currentState')

  isPlaying: ( ->
    return @get('stateManager.currentState.name') == 'playing'
  ).property('stateManager.currentState')
