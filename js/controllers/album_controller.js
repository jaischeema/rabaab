(function() {
  App.AlbumRoute = Ember.Route.extend({
    model: function(params) {
      return Ember.$.getJSON("" + App.squirrel_url + "/album?id=" + params.album_id);
    },
    actions: {
      play: function(song) {
        return this.controllerFor('player').enqueue(song);
      }
    }
  });

  App.AlbumController = Ember.ObjectController.extend();

}).call(this);
