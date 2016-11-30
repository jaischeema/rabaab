module Model exposing (..)

import RemoteData exposing (RemoteData(..), WebData)
import Types exposing (..)


type PlayState
    = Playing
    | Paused
    | Buffering
    | Idle


type Page
    = HomePage
    | PlaylistPage Playlist


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


type alias PlayingInfo =
    { song : Song
    , elapsedTime : Int
    , duration : Int
    , state : PlayState
    }


type alias Model =
    { playlists : WebData (List Playlist)
    , currentPage : Page
    , currentPlaying : Maybe PlayingInfo
    , queue : List Song
    }


initModel : Model
initModel =
    { playlists = NotAsked
    , currentPage = HomePage
    , currentPlaying = Nothing
    , queue = []
    }
