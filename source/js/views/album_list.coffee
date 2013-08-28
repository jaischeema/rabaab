app.directive 'albumList', ->
  restrict: 'A'
  scope:
    albums: "="
    onAlbumSelect: "&"
  templateUrl: 'album-list'