window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.squirrel_url = "http://squirrel.jaischeema.com/api"

App.IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo('latest_albums')

App.Router.map ->
  @resource 'latest_albums'
  @resource 'album', path: '/album/:album_id'
