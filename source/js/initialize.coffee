@app = angular.module("perann", ['ngRoute'])

app.config ($routeProvider, $locationProvider) ->
  $routeProvider.when('/',
    templateUrl: 'latest-albums'
    controller: 'LatestAlbumsCtrl'
    )
  .when('/album/:albumId',
    templateUrl: 'album'
    controller: 'AlbumCtrl'
    )
  .when('/search/:type/:query',
    templateUrl: 'search'
    controller: 'SearchCtrl'
    )

app.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.cache = true
  $httpProvider.interceptors.push ($q, $rootScope) ->
    return (
      'request': (config) ->
        if /squirrel/.test(config.url)
          NProgress.start()
        return config or $q.when config
      'response': (response) ->
        if /squirrel/.test(response.config.url)
          NProgress.done()
        return response
    )
]