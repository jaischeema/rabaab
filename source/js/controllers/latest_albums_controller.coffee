App.LatestAlbumsRoute = Ember.Route.extend
  model: ->
    return new Ember.RSVP.Promise (resolve) ->
      posts = []
      $.getJSON "#{App.squirrel_url}/latest_albums.json", (data) ->
        for album in data.albums
          post = App.Album.create()
          post.setProperties(album)
          posts.push post
        resolve(posts)

App.LatestAlbumsController = Ember.ArrayController.extend
  album_count: ( ->
    this.get('model.length')
  ).property()

