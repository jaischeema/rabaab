module View exposing (..)

import Html exposing (Html, text, div, table, tbody, td, th, tr, img, thead)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Model exposing (..)
import RemoteData exposing (..)


view : Model -> Html Msg
view model =
    case model.data of
        NotAsked ->
            text "Initialising"

        Loading ->
            text "Loading"

        Failure err ->
            text (toString err)

        Success data ->
            case data.currentPage of
                HomePage ->
                    renderPlaylists data.playlists

                PlaylistPage playlist ->
                    renderSongs playlist.songs


renderPlaylists : List Playlist -> Html Msg
renderPlaylists playlists =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "Id" ]
                , th [] [ text "Title" ]
                , th [] [ text "Songs" ]
                ]
            ]
        , tbody [] (List.map renderPlaylist playlists)
        ]


renderPlaylist : Playlist -> Html Msg
renderPlaylist playlist =
    tr [ onClick <| ChangePage (PlaylistPage playlist) ]
        [ td [] [ text <| toString playlist.id ]
        , td [] [ text playlist.title ]
        , td [] [ text <| toString <| List.length playlist.songs ]
        ]


renderSongs : List Song -> Html Msg
renderSongs songs =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "Id" ]
                , th [] [ text "Title" ]
                , th [] [ text "Album title" ]
                ]
            ]
        , tbody [] (List.map renderSong songs)
        ]


renderSong : Song -> Html Msg
renderSong song =
    tr []
        [ td [] [ img [ src song.cover, width 75, height 75 ] [] ]
        , td [] [ text song.title ]
        , td [] [ text song.albumTitle ]
        ]
