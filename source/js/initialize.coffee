@app = angular.module("perann", ['ngRoute'])

app.config ($routeProvider, $locationProvider) ->
  $routeProvider.when('/',
    templateUrl: 'latest-albums'
    controller: "LatestAlbumsCtrl"
  )
  $locationProvider.html5Mode(true)