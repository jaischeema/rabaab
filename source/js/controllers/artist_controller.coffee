App.ArtistRoute = Ember.Route.extend
  model: (params) ->
    return Ember.$.getJSON("#{App.squirrel_url}/artist?id=#{params.artist_id}")

App.ArtistController = Ember.ObjectController.extend()
