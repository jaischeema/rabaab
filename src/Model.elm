module Model exposing (..)

import RemoteData exposing (WebData)
import Types exposing (..)


type Msg
    = PlaylistsResponse (WebData (List Playlist))
    | ChangePage Page


type alias Model =
    { data : WebData AppData }


type Page
    = HomePage
    | PlaylistPage Playlist


type alias AppData =
    { playlists : List Playlist
    , currentPage : Page
    }
