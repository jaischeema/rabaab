app.directive 'albumList', ->
  restrict: 'A'
  scope:
    groups: "="
  controller: ($scope, $location) ->
    $scope.showAlbum = (album_id) ->
      $location.path "album/#{album_id}"
  templateUrl: 'album-list'