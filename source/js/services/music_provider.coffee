app.provider 'player', ->
  prepared = false
  return {
    $get: ->
      console.log("yupp")

    play: (song_id, url) ->
      mySound = new buzz.sound(url,
        preload: true,
        autoplay: true,
        loop: false
      )
  }