var app = angular.module("perann", []);


app.factory('dataFactory', ['$http', function($http) {
  var urlBase = 'http://squirrel.jaischeema.com/v1/';
  var dataFactory = {};

  dataFactory.getLatestAlbums = function () {
    return $http.get(urlBase + "latest_albums");
  };

  dataFactory.getAlbum = function(albumID) {
    return $http.get(urlBase + "album?id=" + albumID);
  };
  return dataFactory;
}]);

app.directive('album', function(){
  return {
    restrict: "E",
    template: "<div>hello</div>"
  };
});

app.controller("MainCtrl", ['$scope', 'dataFactory', function($scope, dataFactory){
  $scope.latest_albums = [];
  getLatestAlbums();
  function getLatestAlbums() {
    dataFactory.getLatestAlbums().success(function(albums){
      $scope.latest_albums = albums.albums;
    })
  }

  function showAlbum(album) {
    console.log(album);
  };

  $scope.$on('showAlbum', function(){
    console.log("yayyy");
  });

}]);