// Generated by CoffeeScript 1.6.3
(function() {
  Ember.SoundPlayerView = Ember.View.extend({
    init: function() {
      var manager,
        _this = this;
      manager = Ember.SoundPlayerManager.create();
      this.set("stateManager", manager);
      soundManager.onready(function() {
        manager.send('ready');
        return _this.loadSound();
      });
      return this._super();
    },
    soundLoaded: function() {
      this.get('stateManager').send('loaded');
      this.set('position', 0);
      return this.set('duration', this.get('sound').duration);
    },
    loadSound: function() {
      var _this = this;
      if (!this.get('isStopped')) {
        this.stop();
      }
      if (!this.soundObject) {
        this.soundObject = soundManager.createSound({
          url: this.get('url'),
          onload: function() {
            return _this.soundLoaded();
          },
          whileplaying: function() {
            return _this.tick();
          },
          onfinish: this.finish()
        });
        return this.soundObject.load();
      }
    },
    sound: (function() {
      this.loadSound();
      return this.soundObject;
    }).property('url'),
    play: function() {
      if (this.get('isStopped')) {
        this.get('sound').play();
      } else {
        this.get('sound').resume();
      }
      return this.get('stateManager').send('play');
    },
    pause: function() {
      this.get('soundManager').send('pause');
      return this.get('sound').pause();
    },
    toggle: function() {
      if (this.get('isPlaying')) {
        return this.pause();
      } else {
        return this.play();
      }
    },
    stop: function() {
      this.get('stateManager').send('stop');
      this.get('sound').stop();
      return this.set('position', 0);
    },
    finish: function() {
      this.get('stateManager').send('stop');
      return this.set('position', 0);
    },
    tick: function() {
      return this.set('position', this.get('sound').position);
    },
    isLoading: (function() {
      return this.get('stateManager.currentState.name') === 'unloaded';
    }).property('stateManager.currentState'),
    isStopped: (function() {
      return !/^started\./.test(this.get('stateManager.currentState.path'));
    }).property('stateManager.currentState'),
    isPlaying: (function() {
      return this.get('stateManager.currentState.name') === 'playing';
    }).property('stateManager.currentState')
  });

}).call(this);