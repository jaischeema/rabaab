module Types exposing (..)


type alias DownloadLink =
    String


type alias Artist =
    String


type alias Genre =
    String


type SongType
    = Single
    | AlbumSong


type alias Song =
    { id : String
    , title : String
    , genre : List Genre
    , songType : String
    , releasedOn : Maybe String
    , artists : List Artist
    , downloadLinks : List DownloadLink
    , category : Maybe String
    , albumId : Maybe String
    , albumTitle : String
    , cover : String
    , loaded : Bool
    }


type alias Playlist =
    { id : Int
    , title : String
    , songs : List Song
    }


type alias Album =
    { id : String
    , title : String
    , trackCount : Int
    , genre : List Genre
    , releasedOn : Maybe String
    , category : Maybe String
    , cover : String
    , artists : List Artist
    , songs : List Song
    }
