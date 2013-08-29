app.factory 'dataFactory', [ '$http', ($http) ->
  base_url = 'http://squirrel.jaischeema.com/v1'
  test_mode = true
  unless test_mode
    return {
      getLatestAlbums: -> $http.get("#{base_url}/latest_albums")
      getAlbum: (id) -> $http.get("#{base_url}/album?id=#{id}")
      getSong: (id) -> $http.get("#{base_url}/song?id=#{id}")
    }
  else
    return {
      getLatestAlbums: -> $http.get("/test/latest_albums.json")
      getAlbum: (id) -> $http.get("/test/album.json")
      getSong: (id) -> $http.get("/test/track.json")
    }
]