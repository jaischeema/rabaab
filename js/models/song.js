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
