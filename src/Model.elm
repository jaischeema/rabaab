module Model exposing (..)

import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)
import Array exposing (..)


type PlayState
    = Playing
    | Paused
    | Buffering
    | Idle


type SearchType
    = Song
    | Album
    | Artist


type Page
    = HomePage
    | PlaylistPage Playlist
    | SearchPage String Int SearchType
    | AlbumPage Album
    | ArtistPage Artist Int


type Msg
    = PlaylistsResponse (WebData (List Playlist))
    | ChangePage Page
    | PlaySong Song
    | AddSongToQueue Song
    | RemoveSongFromQueue Song
    | MoveSongInQueue Song Int
    | Pause
    | Play
    | Next
    | Previous
    | SeekTo Int
    | ChangePlayerState String
    | ChangePlayerCurrentTime Float
    | ChangePlayerDownloadedProgress Float
    | ChangePlayerDuration Float
    | ItemEnded String


type alias PlayingInfo =
    { song : Song
    , currentTime : Float
    , duration : Float
    , downloadProgress : Float
    , state : PlayState
    }


type alias Model =
    { playlists : WebData (List Playlist)
    , currentPage : Page
    , player : Maybe PlayingInfo
    , queue : Array Song
    }


initModel : Model
initModel =
    { playlists = NotAsked
    , currentPage = HomePage
    , player = Nothing
    , queue = Array.empty
    }
