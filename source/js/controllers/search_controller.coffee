App.SearchRoute = Ember.Route.extend
  model: (params) ->
    query = params.query
    tokens = query.split(":")
    if tokens.length == 1
      search_term = tokens[0]
      search_type = "album"
    else
      search_term = tokens[1]
      types =
        a: "album"
        s: "song"
        e: "artist"
      search_type = types[tokens[0]]
    if search_type? and search_term?
      return Ember.$.getJSON("#{App.squirrel_url}/search?query=#{search_term}&type=#{search_type}")
    else
      @transitionTo('latest_albums')

App.SearchController = Em.ObjectController.extend
  isAlbum: ( ->
    @get('type') == "album"
  ).property('type')
  isArtist: ( ->
    @get('type') == "artist"
  ).property('type')
  isSong: ( ->
    @get('type') == "song"
  ).property('type')
