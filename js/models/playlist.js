(function() {
  var PLAYLIST_CURRENT_INDEX, PLAYLIST_SONGS_PATH;

  PLAYLIST_SONGS_PATH = 'rabaab.playlist.songs';

  PLAYLIST_CURRENT_INDEX = 'rabaab.playlist.index';

  App.Playlist = Em.Object.extend({
    songs: [],
    currentIndex: -1,
    isLocal: false,
    currentSong: (function() {
      return this.get('songs')[this.get('currentIndex')];
    }).property('songs', 'currentIndex'),
    currentSongID: (function() {
      return this.get('currentSong').id;
    }).property('currentSong'),
    addSong: function(song) {
      if (this.hasSong(song)) {
        return Ember.debug("Song is already in the playlist");
      } else {
        this.get('songs').pushObject(song);
        if (this.get('songs').length === 1) {
          this.set('currentIndex', 0);
        }
        return this.save();
      }
    },
    removeSong: function(songID) {
      var currentIndex, index, song;
      song = this.songForID(songID);
      if (song != null) {
        index = this.get('songs').indexOf(song);
        currentIndex = this.get('currentIndex');
        if (index <= currentIndex) {
          this.set('currentIndex', currentIndex - 1);
        }
        this.get('songs').splice(index, 1);
        return this.save();
      }
    },
    getSongForPlaying: function(songID) {
      var index, song;
      song = this.songForID(songID);
      if (song != null) {
        index = this.get('songs').indexOf(song);
        if (index === this.get('currentIndex')) {
          return null;
        } else {
          this.set('currentIndex', index);
        }
      }
      return song;
    },
    songForID: function(songID) {
      var _i, _len, _ref, _song;
      _ref = this.get('songs');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _song = _ref[_i];
        if (_song.id === songID) {
          return _song;
        }
      }
      return null;
    },
    hasSong: function(song) {
      return this.songForID(song.id) != null;
    },
    next: function() {
      var current_index;
      current_index = this.get('currentIndex');
      if (current_index !== -1 && current_index < this.get('songs').length) {
        current_index = current_index + 1;
        this.set('currentIndex', current_index);
        return this.get('songs')[current_index];
      }
    },
    previous: function() {
      var current_index;
      current_index = this.get('currentIndex');
      if (current_index !== -1 && current_index > 0) {
        current_index = current_index - 1;
        this.set('currentIndex', current_index);
        return this.get('songs')[current_index];
      }
    },
    save: function() {
      var song_attrs, _i, _len, _ref, _song;
      if (!this.get('isLocal')) {
        return;
      }
      song_attrs = [];
      _ref = this.get('songs');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _song = _ref[_i];
        song_attrs.pushObject(_song.toLocalHash());
      }
      return localStorage.setItem(PLAYLIST_SONGS_PATH, JSON.stringify(song_attrs));
    },
    currentIndexChanged: (function() {
      return localStorage.setItem(PLAYLIST_CURRENT_INDEX, this.get('currentIndex'));
    }).observes('currentIndex')
  });

  App.Playlist.reopenClass({
    createFromLocalStorage: function() {
      var current_index, playlist, song_attrs, song_list, songs, _i, _len, _ref, _ref1;
      playlist = App.Playlist.create();
      playlist.set('isLocal', true);
      song_list = localStorage.getItem(PLAYLIST_SONGS_PATH);
      if (song_list != null) {
        songs = [];
        _ref = JSON.parse(song_list);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          song_attrs = _ref[_i];
          songs.pushObject(App.Song.create(song_attrs));
        }
        playlist.set('songs', songs);
      }
      current_index = localStorage.getItem(PLAYLIST_CURRENT_INDEX);
      playlist.set('index', (_ref1 = current_index != null) != null ? _ref1 : {
        current_index: -1
      });
      return playlist;
    }
  });

}).call(this);
