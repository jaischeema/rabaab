window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.squirrel_url = "http://squirrel.jaischeema.com/api"
App.media_url_key = "normal_quality_url"

App.initializer
  name: "soundmanager"
  initialize: ->
    soundManager.setup
      url: '/js/vendor/'
      flashVersion: 9
      preferFlash: true

App.IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo('latest_albums')

App.Router.map ->
  @resource 'latest_albums'
  @resource 'album', path: '/album/:album_id'
  @resource 'artist', path: '/artist/:artist_id'
  @resource 'search', path: '/search/:query'

App.ApplicationController = Em.ObjectController.extend
  query: ''
  actions:
    search: ->
      query = @get('query')
      @set('query', '')
      @transitionToRoute('search', query)
