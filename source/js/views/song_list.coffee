app.directive 'songList', ->
  restrict: 'A'
  scope:
    songs: "="
    onSongSelect: "&"
  templateUrl: 'song-list'