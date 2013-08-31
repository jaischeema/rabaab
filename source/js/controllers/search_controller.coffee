app.controller 'SearchCtrl', ['$scope', '$routeParams', 'dataFactory', ($scope, $routeParams, dataFactory) ->
  $scope.type = $routeParams.type
  $scope.query = $routeParams.query
  $scope.results = []

  search = ->
    dataFactory.search($scope.type, $scope.query).success (data) ->
      $scope.results = data.results.chunk(4)

  search()
]