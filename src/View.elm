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
                    div [ class "page" ]
                        [ a [ onClick <| ChangePage HomePage ] [ text "Go Back" ]
                        , renderSongs playlist.songs
                        ]
    in
        div [ class "wrapper" ]
            [ renderNavbar currentPage
            , div [ class "container" ] [ pageContent ]
            , div [ class "player" ] [ renderPlayer currentPlaying ]
            ]


renderNavbar : Page -> Html Msg
renderNavbar page =
    div [ class "navbar navbar-dark bg-inverse" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", onClick <| ChangePage HomePage ] [ text "Rabaab" ]
            , ul [ class "nav navbar-nav" ]
                [ navLink "Latest Playlists" HomePage page
                , navLink "Queue" HomePage page
                ]
            ]
        ]


navLink : String -> Page -> Page -> Html Msg
navLink title destination current =
    li [ classList [ ( "active", destination == current ), ( "nav-item", True ) ] ]
        [ a [ class "nav-link", onClick <| ChangePage destination ] [ text title ]
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
        [ div [ class "col-xs-12 hidden-lg-up song-info mobile-song-info" ]
            [ renderCurrentSongInfo data ]
        , div [ class "col-lg-6 player-controls" ]
            [ div [ class "row" ]
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
    case playingInfo of
        Nothing ->
            text "No track is playing right now"

        Just info ->
            div [ class "playing-info" ]
                [ span [ class "playing-info__title" ] [ text info.song.title ]
                , span [ class "playing-info__album_artists" ] [ metaInfo info.song ]
                ]


metaInfo : Song -> Html Msg
metaInfo song =
    let
        artistTitles =
            String.join ", " song.artists

        info =
            song.albumTitle ++ " - " ++ artistTitles
    in
        text info


renderPlaylists : List Playlist -> Html Msg
renderPlaylists playlists =
    div [ class "collection" ] (List.map renderPlaylist playlists)


renderPlaylist : Playlist -> Html Msg
renderPlaylist playlist =
    div [ class "collection__item", onClick <| ChangePage (PlaylistPage playlist) ]
        [ img [ class "collection__item__image", src "/static/media/artwork.3eb76a6e.png" ] []
        , div [ class "collection__item__content" ]
            [ h4 [ class "collection__item__title" ] [ text playlist.title ]
            ]
        ]


renderSongs : List Song -> Html Msg
renderSongs songs =
    div [ class "list" ] (List.map renderSong songs)


renderSong : Song -> Html Msg
renderSong song =
    div [ class "list__item", onClick <| PlaySong song ]
        [ img [ class "list__item__image", src song.cover ] []
        , div [ class "list__item__content" ]
            [ span [ class "list__item__title" ] [ text song.title ]
            , span [ class "list__item__sub_title" ] [ metaInfo song ]
            ]
        ]
