(function() {
  var KeyboardProvider;

  KeyboardProvider = (function() {
    function KeyboardProvider($scope) {
      this.$scope = $scope;
      this.setupMusicEvents();
    }

    KeyboardProvider.prototype.setupMusicEvents = function() {
      Mousetrap.bind('space', (function(_this) {
        return function() {
          return _this.$scope.$broadcast('togglePlayPause');
        };
      })(this));
      Mousetrap.bind('j+k', (function(_this) {
        return function() {
          return _this.$scope.$broadcast('next');
        };
      })(this));
      Mousetrap.bind('j+h', (function(_this) {
        return function() {
          return _this.$scope.$broadcast('shuffle');
        };
      })(this));
      Mousetrap.bind('f+d', (function(_this) {
        return function() {
          return _this.$scope.$broadcast('previous');
        };
      })(this));
      return Mousetrap.bind('f+g', (function(_this) {
        return function() {
          return _this.$scope.$broadcast('repeat');
        };
      })(this));
    };

    return KeyboardProvider;

  })();

}).call(this);
