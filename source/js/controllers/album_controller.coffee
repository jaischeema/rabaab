App.AlbumRoute = Ember.Route.extend
  model: (params) ->
    return Ember.$.getJSON("#{App.squirrel_url}/album?id=#{params.album_id}")
  actions:
    play: (song) ->
      @controllerFor('player').enqueue(song)

App.AlbumController = Ember.ObjectController.extend()
