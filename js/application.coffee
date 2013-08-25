app = angular.module("perann", [])

app.factory 'dataFactory', [ '$http', ($http) ->
  base_url = 'http://localhost:9292/v1'
  return {
    getLatestAlbums: -> $http.get("#{base_url}/latest_albums")
    getAlbum: (id) -> $http.get("#{base_url}/album?id=#{id}")
  }
]

app.directive 'album', ->
  restrict: 'A'
  template: '{{album.title}}'
  controller: ($scope) ->
    $scope.showAlbum = ->
      console.log $scope.album.title

app.controller "MainCtrl", ['$scope', 'dataFactory', ($scope, dataFactory) ->
  $scope.latest_albums = []
  getLatestAlbums = ->
    dataFactory.getLatestAlbums().success (albums) ->
      $scope.latest_albums = albums.albums
  getLatestAlbums()
]