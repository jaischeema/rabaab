app.controller 'PlayerCtrl', ['$scope', 'musicManager', ($scope, musicManager) ->
  $scope.previous = -> musicManager.previous()
  $scope.play = -> musicManager.togglePlayPause()
  $scope.next = -> musicManager.next()

  $scope.$on 'trackAdded', (event, track) ->
    console.log "changed track"

  $scope.$on 'stateChanged', (event, state) ->
    console.log "changed state"
]