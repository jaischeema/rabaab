module View exposing (..)

import Html exposing (Html, text, div, table, tbody, td, th, tr, img, thead)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Model exposing (..)
import RemoteData exposing (..)


view : Model -> Html Msg
view { playlists, currentPage, currentPlaying } =
    let
        pageContent =
            case currentPage of
                HomePage ->
                    renderHomePage playlists

                PlaylistPage playlist ->
                    renderSongs playlist.songs
    in
        div [ class "wrapper" ]
            [ div [ class "content" ] [ pageContent ]
            , div [ class "player" ] [ renderPlayer currentPlaying ]
            ]


renderHomePage : WebData (List Playlist) -> Html Msg
renderHomePage playlistsData =
    case playlistsData of
        NotAsked ->
            text "Initialising"

        Loading ->
            text "Loading"

        Failure err ->
            text (toString err)

        Success playlists ->
            renderPlaylists playlists


renderPlayer : Maybe PlayingInfo -> Html Msg
renderPlayer data =
    case data of
        Just playingInfo ->
            div [ class "player" ]
                [ text playingInfo.song.title
                , text playingInfo.song.albumTitle
                ]

        Nothing ->
            text "Nothing"


renderPlaylists : List Playlist -> Html Msg
renderPlaylists playlists =
    table [ class "table" ]
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
    table [ class "table" ]
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
    tr [ onClick <| PlaySong song ]
        [ td [] [ img [ src song.cover, width 75, height 75 ] [] ]
        , td [] [ text song.title ]
        , td [] [ text song.albumTitle ]
        ]
