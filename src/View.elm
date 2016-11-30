module View exposing (..)

import Html exposing (..)
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
    div [ class "player-bar row" ]
        [ div [ class "hidden-lg-up song-info mobile-song-info" ]
            [ renderCurrentSongInfo data ]
        , div [ class "col-lg-6" ]
            [ div [ class "row player-controls" ]
                [ a [ class "col-xs-2 player-button previous-button" ]
                    [ i [ class "fa fa-fast-backward" ] [] ]
                , a [ class "col-xs-2 player-button play-button" ]
                    [ i [ class "fa fa-play" ] [] ]
                , a [ class "col-xs-2 player-button stop-button" ]
                    [ i [ class "fa fa-stop" ] [] ]
                , a [ class "col-xs-2 player-button next-button" ]
                    [ i [ class "fa fa-fast-forward" ] [] ]
                , a [ class "col-xs-2 player-button shuffle-button" ]
                    [ i [ class "fa fa-random" ] [] ]
                , a [ class "col-xs-2 player-button repeat-button" ]
                    [ i [ class "fa fa-refresh" ] [] ]
                ]
            ]
        , div [ class "hidden-md-down col-lg-6 song-info" ]
            [ renderCurrentSongInfo data ]
        ]


renderCurrentSongInfo : Maybe PlayingInfo -> Html Msg
renderCurrentSongInfo playingInfo =
    text "No track is playing right now"


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
