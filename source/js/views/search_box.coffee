app.directive 'searchBox', ->
  restrict: 'C'
  templateUrl: 'search-box'
  controller: ($scope, $location) ->
    unless $scope.query == ""
      $scope.search = -> $location.path "/search/album/#{encodeURIComponent($scope.query)}"