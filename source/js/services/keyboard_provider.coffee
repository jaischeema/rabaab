class KeyboardProvider
  constructor: (@$scope) ->
    @setupMusicEvents()

  setupMusicEvents: ->
    Mousetrap.bind 'space', => @$scope.$broadcast 'togglePlayPause'
    Mousetrap.bind 'j+k', => @$scope.$broadcast 'next'
    Mousetrap.bind 'j+h', => @$scope.$broadcast 'shuffle'
    Mousetrap.bind 'f+d', => @$scope.$broadcast 'previous'
    Mousetrap.bind 'f+g', => @$scope.$broadcast 'repeat'

app.factory 'keyboardProvider', ($rootScope) -> new KeyboardProvider($rootScope)