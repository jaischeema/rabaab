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