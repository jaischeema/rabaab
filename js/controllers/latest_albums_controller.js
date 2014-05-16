(function() {
  App.LatestAlbumsRoute = Ember.Route.extend({
    model: function() {
      return new Ember.RSVP.Promise(function(resolve) {
        var posts;
        posts = [];
        return $.getJSON("" + App.squirrel_url + "/latest_albums.json", function(data) {
          var album, post, _i, _len, _ref;
          _ref = data.albums;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            album = _ref[_i];
            post = App.Album.create();
            post.setProperties(album);
            posts.push(post);
          }
          return resolve(posts);
        });
      });
    }
  });

  App.LatestAlbumsController = Ember.ArrayController.extend({
    album_count: (function() {
      return this.get('model.length');
    }).property()
  });

}).call(this);
