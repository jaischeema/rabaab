//= require './vendor/soundmanager/soundmanager2'
//= require './vendor/nprogress'
//= require 'main'
//= require_tree './controllers'
//= require_tree './services'
//= require_tree './views'

app.provider 'player', ->
  prepared = false
  return {
    $get: ->
      soundManager.setup
        url: '/js/vendor/soundmanager/flash/'
        flashVersion: 9
        preferFlash: true
        onready: => @ready = true
        ontimeout: -> alert "Not able to initialise SoundManager, please contact admin."

    play: (song_id, url) ->
      song_id = "song-#{song_id}"
      console.log song_id
      soundManager.createSound()
  }