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
