app = angular.module("perann", [])

app.factory 'dataFactory', [ '$http', ($http) ->
  base_url = 'http://squirrel.jaischeema.com/v1'
  return {
    getLatestAlbums: -> $http.get("#{base_url}/latest_albums")
    getAlbum: (id) -> $http.get("#{base_url}/album?id=#{id}")
  }
]

app.directive 'albumList', ->
  restrict: 'A'
  scope:
    albums: "="
    onAlbumSelect: "&"
  template: '<li class="album-cell" ng-repeat="album in albums"><a href="#" ng-click="onAlbumSelect({album: album})">{{album.title}} <small>by {{album.artist_title}}</small><a/></li>'

app.directive 'songList', ->
  restrict: 'A'
  scope:
    songs: "="
    onSongSelect: "&"
  template: '<li class="song-cell" ng-repeat="song in songs"><a href="#" ng-click="onSongSelect({song: song})">{{song.title}} <small>- {{song.artist_title}}</small><a/></li>'

app.directive 'album', ->
  restrit: 'A'
  replace: true
  scope:
    album: "="
  template: "<h1 class='title'>{{album.title}}</h1><div class='list-group'><a class='list-group-item'></a></div>"

app.controller "MainCtrl", ['$scope', 'dataFactory', ($scope, dataFactory) ->
  $scope.latest_albums = []
  $scope.showingAlbum = true
  $scope.currentAlbum = null
  getLatestAlbums = ->
    dataFactory.getLatestAlbums().success (albums) ->
      $scope.latest_albums = albums.albums

  $scope.showAlbum = (album) ->
    dataFactory.getAlbum(album.id).success (album_data) ->
      $scope.currentAlbum = album_data

  $scope.$watch 'currentAlbum', ->
    if $scope.currentAlbum == null
      $scope.showingAlbum = false
    else
      $scope.showingAlbum = true
      console.log $scope.currentAlbum

  getLatestAlbums()
]