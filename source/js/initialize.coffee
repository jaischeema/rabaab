window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo("latest_albums")

App.Router.map ->
  @resource 'latest_albums'
  @resource 'album', { path: '/albums/:album_id'}
