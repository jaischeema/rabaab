app.controller "LatestAlbumsCtrl", ['$scope', 'dataFactory', ($scope, dataFactory) ->
  $scope.latest_albums = []

  getLatestAlbums = ->
    dataFactory.getLatestAlbums().success (albums) ->
      $scope.latest_albums = albums.albums.chunk(4)

  getLatestAlbums()
]