app.factory 'dataFactory', [ '$http', ($http) ->
  base_url = 'http://squirrel.jaischeema.com/v1'
  return {
    getLatestAlbums: -> $http.get("#{base_url}/latest_albums")
    getAlbum: (id) -> $http.get("#{base_url}/album?id=#{id}")
    getSong: (id) -> $http.get("#{base_url}/song?id=#{id}")
  }
]