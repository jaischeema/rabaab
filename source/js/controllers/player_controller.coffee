app.controller 'PlayerCtrl', ['$scope', 'musicManager', ($scope, musicManager) ->
  $scope.previous = -> musicManager.previous()
  $scope.play = -> musicManager.togglePlayPause()
  $scope.next = -> musicManager.next()

  $scope.position = 0
  $scope.duration = 0
  $scope.positionPercent = 0
  $scope.title = ''
  $scope.artistTitle = ''
  $scope.loadPercent = 0
  $scope.playing = false
  $scope.enabled = false

  $scope.$on 'trackAdded', (event, track) ->
    console.log "changed track"

  $scope.$on 'stateChanged', (event, state) ->
    if state == MusicManagerState.playing
      $scope.playing = true
      $scope.enabled = true
      song = musicManager.currentSong()
      $scope.title = song.title
      $scope.artistTitle = song.artist_title
    else if state == MusicManagerState.paused
      $scope.playing = false
    else if state == MusicManagerState.waiting or state == MusicManagerState.inactive
      $scope.playing = false
      $scope.enabled = false

  $scope.$on 'playPositionChanged', (event, position, duration) ->
    $scope.position = position
    $scope.duration = duration
    if duration > 0
      $scope.positionPercent = (position/duration) * 100.00
    else
      $scope.positionPercent = 0

  $scope.$on 'loadPositionChanged', (event, bytesLoaded, totalBytes) ->
    if totalBytes > 0
      $scope.loadPercent = (bytesLoaded/totalBytes) * 100.00
    else
      $scope.loadPercent = 0
]