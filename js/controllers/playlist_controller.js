(function() {
  App.PlaylistController = Ember.ObjectController.extend({
    needs: ['player'],
    init: function() {
      this._super();
      return this.set('model', App.Playlist.createFromLocalStorage());
    },
    loadPlaylist: function(id) {
      return console.log("Loaded playlist " + id);
    },
    enqueue: function(song) {
      return this.get('model').addSong(song);
    },
    next: function() {
      return this.get('model').next();
    },
    previous: function() {
      return this.get('model').previous();
    },
    getSongForPlaying: function(id) {
      return this.get('model').getSongForPlaying(id);
    },
    actions: {
      playSong: function(song_id) {
        var song;
        song = this.getSongForPlaying(song_id);
        if (song != null) {
          return this.get('controllers.player').resetCurrentModel(song);
        }
      },
      removeSong: function(song_id) {
        return this.get('model').removeSong(song_id);
      }
    }
  });

}).call(this);
