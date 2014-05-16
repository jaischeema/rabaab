(function() {
  var MusicManager;

  this.MusicManagerState = Object.freeze({
    "inactive": 1,
    "waiting": 2,
    "playing": 3,
    "paused": 4
  });

  MusicManager = (function() {
    function MusicManager($scope) {
      this.$scope = $scope;
      this.playlist = {};
      this.state = MusicManagerState.inactive;
      this.playlistIds = [];
      this.volume = 40;
      this.setupKeyboardListeners();
    }

    MusicManager.prototype.setupKeyboardListeners = function() {
      this.$scope.$on('togglePlayPause', (function(_this) {
        return function() {
          return _this.togglePlayPause();
        };
      })(this));
      this.$scope.$on('next', (function(_this) {
        return function() {
          return _this.next();
        };
      })(this));
      return this.$scope.$on('previous', (function(_this) {
        return function() {
          return _this.previous();
        };
      })(this));
    };

    MusicManager.prototype.createSong = function(id, url) {
      var self;
      self = this;
      return this.currentSound = soundManager.createSound({
        id: "sound-" + id,
        url: url,
        autoLoad: true,
        autoPlay: true,
        onload: function() {
          return self.changeState(MusicManagerState.playing);
        },
        whileplaying: function() {
          return self.safeApply((function(_this) {
            return function() {
              return self.$scope.$broadcast('playPositionChanged', _this.position, _this.duration);
            };
          })(this));
        },
        whileloading: function() {
          return self.safeApply((function(_this) {
            return function() {
              return self.$scope.$broadcast('loadPositionChanged', _this.bytesLoaded, _this.bytesTotal);
            };
          })(this));
        },
        onfinish: function() {
          return self.next();
        },
        volume: this.volume
      });
    };

    MusicManager.prototype.currentState = function() {
      return this.state;
    };

    MusicManager.prototype.changeState = function(state) {
      this.state = state;
      return this.safeApply((function(_this) {
        return function() {
          return _this.$scope.$broadcast('stateChanged', state);
        };
      })(this));
    };

    MusicManager.prototype.enqueue = function(song) {
      var song_id;
      song_id = "song-" + song.id;
      if (!this.playlist.hasOwnProperty(song_id)) {
        this.playlist[song_id] = song;
        this.playlistIds.push(song_id);
        this.$scope.$broadcast('trackAdded', song);
        if (this.state === MusicManagerState.waiting && (this.currentIndex == null)) {
          this.currentIndex = 0;
          return this.createSong(song_id, song.url);
        }
      } else {
        return console.log("Already in playlist, ignored!");
      }
    };

    MusicManager.prototype.togglePlayPause = function() {
      if (this.state === MusicManagerState.paused) {
        return this.play();
      } else if (this.state === MusicManagerState.playing) {
        return this.pause();
      }
    };

    MusicManager.prototype.play = function() {
      if (this.state === MusicManagerState.paused) {
        this.currentSound.play();
        return this.changeState(MusicManagerState.playing);
      }
    };

    MusicManager.prototype.pause = function() {
      if (this.state === MusicManagerState.playing) {
        this.currentSound.pause();
        return this.changeState(MusicManagerState.paused);
      }
    };

    MusicManager.prototype.next = function() {
      if (this.isInPlayableState() && (this.currentIndex < this.playlistIds.length - 1)) {
        this.currentIndex += 1;
        return this.playSongAtCurrentIndex();
      }
    };

    MusicManager.prototype.previous = function() {
      if (this.isInPlayableState() && this.currentIndex > 0) {
        this.currentIndex -= 1;
        return this.playSongAtCurrentIndex();
      }
    };

    MusicManager.prototype.playAtIndex = function(index) {
      if (this.isInPlayableState() && index >= 0 && index <= this.playlistIds.length - 1) {
        this.currentIndex = index;
        return this.playSongAtCurrentIndex();
      }
    };

    MusicManager.prototype.isInPlayableState = function() {
      return this.state === MusicManagerState.playing || this.state === MusicManagerState.paused;
    };

    MusicManager.prototype.currentSong = function() {
      var song_id;
      song_id = this.playlistIds[this.currentIndex];
      return this.playlist[song_id];
    };

    MusicManager.prototype.songURL = function(index) {
      var song_id;
      song_id = this.playlistIds[index];
      return this.playlist[song_id].url;
    };

    MusicManager.prototype.playSongAtCurrentIndex = function() {
      this.currentSound.destruct();
      return this.createSong(this.playlistIds[this.currentIndex], this.songURL(this.currentIndex));
    };

    MusicManager.prototype.safeApply = function(fn) {
      var phase;
      phase = this.$scope.$root.$$phase;
      if (phase === '$apply' || phase === '$digest') {
        return this.$scope.$eval(fn);
      } else {
        return this.$scope.$apply(fn);
      }
    };

    return MusicManager;

  })();

}).call(this);
