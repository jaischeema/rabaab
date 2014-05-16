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
