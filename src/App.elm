module App exposing (..)

import Model exposing (..)
import Api exposing (playlistsRequest)
import Http
import RemoteData exposing (..)


getPlaylists : Cmd Msg
getPlaylists =
    Http.send (PlaylistsResponse << RemoteData.fromResult) playlistsRequest


init : ( Model, Cmd Msg )
init =
    ( { data = Loading }, getPlaylists )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlaylistsResponse response ->
            let
                data =
                    RemoteData.map (\x -> { playlists = x, currentPage = HomePage }) response
            in
                ( { data = data }, Cmd.none )

        ChangePage page ->
            let
                data =
                    RemoteData.map (\x -> { x | currentPage = page }) model.data
            in
                ( { data = data }, Cmd.none )
