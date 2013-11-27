App.AlbumRoute = Ember.Route.extend
  model: (params) ->
    return Ember.$.getJSON("#{App.squirrel_url}/album?id=#{params.album_id}")

App.AlbumController = Ember.ObjectController.extend()
