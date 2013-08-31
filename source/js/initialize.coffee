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
]