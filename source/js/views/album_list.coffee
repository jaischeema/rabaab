app.directive 'albumList', ->
  restrict: 'A'
  scope:
    groups: "="
  templateUrl: 'album-list'