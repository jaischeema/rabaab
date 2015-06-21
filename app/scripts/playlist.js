var Reflux = require('reflux');

var PlaylistActions = Reflux.createActions([
  "play",
  "pause",
  "next",
  "previous",
  "add",
  "remove",
  "playSong"
]);

var Playlist = Reflux.createStore({
  init: function() {
    this.songs        = this.getFromLocalStorage();
    this.currentIndex = (this.songs.length == 0 ? null : 0);
    this.playing      = true;
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

  onPlaySong: function(song) {
    var songIndex = null;
    for(var index in this.songs) {
      if(this.songs[index] == song) {
        songIndex = index;
        break;
      }
    }
    if(songIndex !== null) {
      this.currentIndex = songIndex;
    } else {
      this.songs.push(song);
      this.currentIndex = this.songs.length - 1;
    }
    this.playing = true;
    this.saveToLocalStorage();
    this.trigger();
  },

  onPause: function() {
    if(this.currentIndex !== null && this.playing) {
      this.playing = false;
      this.trigger();
    }
  },

  onNext: function() {
    if(this.currentIndex !== null && this.songs.length > (this.currentIndex + 1)) {
      this.currentIndex += 1;
      this.trigger();
    }
  },

  onPrevious: function() {
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
    this.saveToLocalStorage();
    this.trigger();
  },

  onRemove: function(song) {
    for(var index in this.songs) {
      if(this.songs[index] == song) {
        this.songs.splice(index, 1);
        if(this.currentIndex == index && this.songs.length == 0) {
          this.currentIndex = null;
        }
        this.saveToLocalStorage();
        this.trigger();
        return
      }
    }
  },

  saveToLocalStorage: function() {
    localStorage.setItem("playlist", JSON.stringify(this.songs));
  },

  getFromLocalStorage: function() {
    var data = localStorage.getItem("playlist");
    if(data !== undefined && data !== null) {
      return JSON.parse(data);
    } else {
      return [];
    }
  }
});

export default {PlaylistActions: PlaylistActions, Playlist: Playlist};
