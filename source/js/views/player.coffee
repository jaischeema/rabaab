app.directive 'player', ['musicManager', ->
  restrict: 'A'
  templateUrl: 'player'
  controller: ($scope) -> console.log("hello")
]