var Reflux = require('reflux');

var PlaylistActions = Reflux.createActions([
  "play",
  "pause",
  "next",
  "previous",
  "add",
  "remove"
]);

var Playlist = Reflux.createStore({
  init: function() {
    this.songs        = [];
    this.currentIndex = null;
    this.playing      = false;
    this.listenToMany(PlaylistActions)
  },

  currentSong: function() {
    return this.songs[this.currentIndex];
  },

  onPlay: function() {
    if(this.currentIndex !== null && !this.playing) {
      this.playing = true;
      this.trigger();
    }
  },

  onPause: function() {
    if(this.currentIndex !== null && this.playing) {
      this.playing = false;
      this.trigger();
    }
  },

  onNext: function() {
    debugger
    if(this.currentIndex !== null && this.songs.length > (this.currentIndex + 1)) {
      this.currentIndex += 1;
      this.trigger();
    }
  },

  onPrevious: function() {
    debugger
    if(this.currentIndex !== null && this.currentIndex > 0) {
      this.currentIndex -= 1;
      this.trigger();
    }
  },

  onAdd: function(song) {
    for(var songObj of this.songs) {
      if(songObj == song) {
        return;
      }
    }
    this.songs.push(song);
    if(this.currentIndex == null) {
      this.currentIndex = 0;
      this.playing      = true;
    }
    this.trigger();
  },

  onRemove: function(song) {
  }
});

export default {PlaylistActions: PlaylistActions, Playlist: Playlist};
