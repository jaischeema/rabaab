app = angular.module("perann", [])

app.factory 'dataFactory', [ '$http', ($http) ->
  base_url = 'http://squirrel.jaischeema.com/v1'
  return {
    getLatestAlbums: -> $http.get("#{base_url}/latest_albums")
    getAlbum: (id) -> $http.get("#{base_url}/album?id=#{id}")
    getSong: (id) -> $http.get("#{base_url}/song?id=#{id}")
  }
]

app.provider 'player', ->
  prepared = false
  return {
    $get: ->
      soundManager.setup
        url: '/js/vendor/soundmanager/flash/'
        flashVersion: 9
        preferFlash: true
        onready: => @ready = true
        ontimeout: -> alert "Not able to initialise SoundManager, please contact admin."

    play: (song_id, url) ->
      song_id = "song-#{song_id}"
      console.log song_id
      soundManager.createSound()
  }

app.directive 'albumList', ->
  restrict: 'A'
  scope:
    albums: "="
    onAlbumSelect: "&"
  templateUrl: 'album-list'

app.directive 'songList', ->
  restrict: 'A'
  scope:
    songs: "="
    onSongSelect: "&"
  templateUrl: 'song-list'

app.controller "MainCtrl", ['$scope', 'dataFactory', 'player', ($scope, dataFactory, player) ->
  $scope.latest_albums = []
  $scope.showingAlbum = true
  $scope.currentAlbum = null

  getLatestAlbums = ->
    dataFactory.getLatestAlbums().success (albums) ->
      $scope.latest_albums = albums.albums

  $scope.showAlbum = (album) ->
    dataFactory.getAlbum(album.id).success (album_data) ->
      $scope.currentAlbum = album_data

  $scope.playSong = (song) ->
    dataFactory.getSong(song.id).success (song_data) ->
      player.play(song_data.id, song_data.low_quality)

  $scope.$watch 'currentAlbum', ->
    if $scope.currentAlbum == null
      $scope.showingAlbum = false
    else
      $scope.showingAlbum = true
      console.log $scope.currentAlbum

  getLatestAlbums()
]