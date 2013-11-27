App.AlbumRoute = Ember.Route.extend
  model: (params) ->
    return Ember.$.getJSON("http://squirrel.jaischeema.com/api/album?id=#{params.album_id}")

App.AlbumController = Ember.ObjectController.extend()
