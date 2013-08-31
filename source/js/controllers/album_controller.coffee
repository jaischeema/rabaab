app.controller 'AlbumCtrl', ['$scope', '$routeParams', 'dataFactory', 'musicManager', ($scope, $routeParams, dataFactory, musicManager) ->
  $scope.albumId = $routeParams.albumId

  getAlbum = ->
    dataFactory.getAlbum($scope.albumId).success (album_data) ->
      $scope.album = album_data

  $scope.playSong = (song) ->
    dataFactory.getSong(song.id).success (song_data) ->
      playlist_song = {id: song.id, title: song.title, artist_title: song.artist_title, album_title: $scope.album.title, url: song_data.low_quality}
      musicManager.enqueue(playlist_song)

  getAlbum()
]