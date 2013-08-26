app = angular.module("perann", [])

app.factory 'dataFactory', [ '$http', ($http) ->
  base_url = 'http://squirrel.jaischeema.com/v1'
  return {
    getLatestAlbums: -> $http.get("#{base_url}/latest_albums")
    getAlbum: (id) -> $http.get("#{base_url}/album?id=#{id}")
  }
]

app.directive 'albumCell', ['dataFactory', (dataFactory) ->
  restrict: 'A'
  template: '{{album.title}} <small>{{album.artist_title}}</small>'
  controller: ($scope) ->
    $scope.showAlbum = ->
      dataFactory.getAlbum($scope.album.id).success (album_data) ->
        console.log album_data
]

app.directive 'album', ->
  restrit: 'A'
  replace: true
  scope:
    album: "="
  template: "<h1 class='title'>{{album.title}}</h1><div class='list-group'><a class='list-group-item'></a></div>"

app.controller "MainCtrl", ['$scope', 'dataFactory', ($scope, dataFactory) ->
  $scope.latest_albums = []
  $scope.showingAlbum = false
  getLatestAlbums = ->
    dataFactory.getLatestAlbums().success (albums) ->
      $scope.latest_albums = albums.albums
  getLatestAlbums()
]