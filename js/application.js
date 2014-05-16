(function() {
  window.App = Ember.Application.create({
    LOG_TRANSITIONS: true
  });

  App.squirrel_url = "http://squirrel.jaischeema.com/api";

  App.media_url_key = "normal_quality_url";

  App.initializer({
    name: "soundmanager",
    initialize: function() {
      return soundManager.setup({
        url: '/js/vendor/',
        flashVersion: 9,
        preferFlash: true
      });
    }
  });

  App.IndexRoute = Ember.Route.extend({
    redirect: function() {
      return this.transitionTo('latest_albums');
    }
  });

  App.Router.map(function() {
    this.resource('latest_albums');
    this.resource('album', {
      path: '/album/:album_id'
    });
    this.resource('artist', {
      path: '/artist/:artist_id'
    });
    return this.resource('search', {
      path: '/search/:query'
    });
  });

  App.ApplicationController = Em.ObjectController.extend({
    query: '',
    actions: {
      search: function() {
        var query;
        query = this.get('query');
        this.set('query', '');
        return this.transitionToRoute('search', query);
      }
    }
  });

}).call(this);
(function() {
  Ember.Handlebars.helper("format-duration", function(s, options) {
    var mins, ms, secs, secs_string;
    if (s == null) {
      return '';
    }
    ms = s % 1000;
    s = (s - ms) / 1000;
    secs = s % 60;
    s = (s - secs) / 60;
    mins = s % 60;
    secs_string = secs < 10 ? "0" + secs : "" + secs;
    return "" + mins + ":" + secs_string;
  });

}).call(this);
(function() {
  App.Album = Ember.Object.extend();

}).call(this);
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
(function() {
  App.Song = Em.Object.extend({
    normal_quality_url: null,
    isPlayable: Ember.computed.bool(App.media_url_key),
    musicURL: Ember.computed.oneWay(App.media_url_key),
    toLocalHash: function() {
      return this.getProperties('id', 'resource_id', 'title', 'artist_title', App.media_url_key);
    },
    refresh: function() {
      var id;
      id = this.get('id');
      return Ember.$.getJSON("" + App.squirrel_url + "/song?id=" + id).then((function(_this) {
        return function(data) {
          return _this.setProperties(data);
        };
      })(this));
    }
  });

}).call(this);
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
(function() {
  App.ArtistRoute = Ember.Route.extend({
    model: function(params) {
      return Ember.$.getJSON("" + App.squirrel_url + "/artist?id=" + params.artist_id);
    }
  });

  App.ArtistController = Ember.ObjectController.extend();

}).call(this);
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
(function() {
  this.PlayerState = Object.freeze({
    waiting: 1,
    playing: 2,
    paused: 3
  });

  App.PlayerController = Ember.ObjectController.extend({
    needs: ['playlist'],
    volume: 40,
    currentState: PlayerState.waiting,
    currentPosition: 0,
    currentDuration: 0,
    currentLoadPercent: 0.00,
    playlist: Ember.computed.alias("controllers.playlist"),
    isPlaying: (function() {
      var state;
      state = this.get('currentState');
      return state === PlayerState.playing || state === PlayerState.paused;
    }).property('currentState'),
    playProgressWidth: (function() {
      var percent;
      percent = (this.get('currentPosition') / this.get('currentDuration')) * 100;
      return "width: " + percent + "%";
    }).property('currentPosition', 'currentDuration'),
    downloadProgressWidth: (function() {
      return "width: " + (this.get('currentLoadPercent')) + "%";
    }).property('currentLoadPercent'),
    playButtonClass: (function() {
      var state;
      state = this.get('currentState');
      if (state === PlayerState.playing) {
        return "icon-pause";
      } else if (state === PlayerState.paused) {
        return "icon-play";
      }
    }).property('currentState'),
    enqueue: function(song) {
      var songObj;
      songObj = App.Song.create(song);
      this.get('playlist').enqueue(songObj);
      if (this.get('model') == null) {
        return this.resetCurrentModel(songObj);
      }
    },
    musicURLFetchedForModel: (function() {
      var model, music_url, self;
      model = this.get('model');
      music_url = model.get('musicURL');
      if (music_url != null) {
        self = this;
        return soundManager.createSound({
          id: "sound-" + model.id,
          url: music_url,
          autoLoad: true,
          onplay: function() {
            self.set('currentSound', this);
            return self.set('currentState', PlayerState.playing);
          },
          onresume: function() {
            return self.set('currentState', PlayerState.playing);
          },
          onpause: function() {
            return self.set('currentState', PlayerState.paused);
          },
          whileplaying: function() {
            self.set('currentPosition', this.position);
            return self.set('currentDuration', this.duration);
          },
          whileloading: function() {
            return self.set('currentLoadPercent', (this.bytesLoaded / this.bytesTotal) * 100);
          },
          onfinish: function() {
            return self.send('next');
          },
          volume: self.get('volume')
        }).play();
      } else {
        return Ember.debug("Music URL not found");
      }
    }).observes('model.musicURL'),
    resetCurrentModel: function(song) {
      var currentSound;
      if (song != null) {
        currentSound = this.get('currentSound');
        if (currentSound != null) {
          currentSound.destruct();
        }
        this.set('currentPosition', 0);
        this.set('currentDuration', 0);
        this.set('currentLoadPercent', 0.00);
        this.set('model', song);
        if (!song.get('isPlayable')) {
          return song.refresh();
        }
      }
    },
    actions: {
      togglePlayPause: function() {
        var current_state;
        current_state = this.get('currentState');
        if (current_state === PlayerState.playing) {
          return this.get('currentSound').pause();
        } else if (current_state === PlayerState.paused) {
          return this.get('currentSound').resume();
        } else {
          return Ember.debug("No sound present");
        }
      },
      playSong: function(song_id) {
        var song;
        song = this.get('playlist').getSongForPlaying(song_id);
        if (song != null) {
          return this.resetCurrentModel(song);
        }
      },
      next: function() {
        var next_song;
        next_song = this.get('playlist').next();
        return this.resetCurrentModel(next_song);
      },
      previous: function() {
        var previous_song;
        previous_song = this.get('playlist').previous();
        return this.resetCurrentModel(previous_song);
      },
      shuffle: function() {
        return Ember.debug("shuffle action");
      },
      repeat: function() {
        return Ember.debug("repeat action");
      }
    }
  });

}).call(this);
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
(function() {


}).call(this);
