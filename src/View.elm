module View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Model exposing (..)
import RemoteData exposing (..)


view : Model -> Html Msg
view { playlists, currentPage, queue, currentPlaying } =
    let
        pageContent =
            case currentPage of
                HomePage ->
                    renderHomePage playlists

                PlaylistPage playlist ->
                    renderSongs playlist.songs
    in
        div [ class "wrapper" ]
            [ renderNavbar currentPage
            , div [ class "container-fluid" ]
                [ div [ class "main" ] [ pageContent ] ]
            , div [ class "player" ] [ renderPlayer currentPlaying ]
            , renderQueue queue currentPlaying
            ]


renderNavbar : Page -> Html Msg
renderNavbar page =
    div [ class "navbar navbar-fixed-top navbar-dark bg-inverse" ]
        [ div [ class "container-fluid" ]
            [ a [ class "navbar-brand", onClick <| ChangePage HomePage ] [ text "Rabaab" ]
            , ul [ class "nav navbar-nav" ]
                [ navLink "Latest Playlists" HomePage page
                ]
            , div [ class "form-inline float-lg-right" ]
                [ input [ class "form-control", type_ "text", placeholder "Search" ] [] ]
            ]
        ]


renderQueue : List Song -> Maybe PlayingInfo -> Html Msg
renderQueue queue playingInfo =
    div [ class "queue" ]
        [ h2 [ class "queue__title" ] [ text "Queue" ]
        , div [ class "queue__list" ] (List.map renderQueueSong queue)
        ]


renderQueueSong : Song -> Html Msg
renderQueueSong song =
    a [ class "queue__list__item" ]
        [ h5 [ class "queue__list__item__title" ] [ text song.title ]
        , p [ class "queue__list__item__subtitle" ] [ metaInfo song ]
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
