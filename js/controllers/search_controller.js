(function() {
  App.SearchRoute = Ember.Route.extend({
    model: function(params) {
      var query, search_term, search_type, tokens, types;
      query = params.query;
      tokens = query.split(":");
      if (tokens.length === 1) {
        search_term = tokens[0];
        search_type = "album";
      } else {
        search_term = tokens[1];
        types = {
          a: "album",
          s: "song",
          e: "artist"
        };
        search_type = types[tokens[0]];
      }
      if ((search_type != null) && (search_term != null)) {
        return Ember.$.getJSON("" + App.squirrel_url + "/search?query=" + search_term + "&type=" + search_type);
      } else {
        return this.transitionTo('latest_albums');
      }
    }
  });

  App.SearchController = Em.ObjectController.extend({
    isAlbum: (function() {
      return this.get('type') === "album";
    }).property('type'),
    isArtist: (function() {
      return this.get('type') === "artist";
    }).property('type'),
    isSong: (function() {
      return this.get('type') === "song";
    }).property('type')
  });

}).call(this);
