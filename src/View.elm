module View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Model exposing (..)
import RemoteData exposing (..)
import Array exposing (..)


view : Model -> Html Msg
view { playlists, currentPage, queue, player } =
    let
        pageContent =
            case currentPage of
                HomePage ->
                    renderHomePage playlists

                PlaylistPage playlist ->
                    renderPlaylistSongs playlist player

                _ ->
                    text "Haven't handled that case yet"
    in
        div [ class "wrapper" ]
            [ renderNavbar currentPage
            , div [ class "container-fluid" ]
                [ div [ class "main" ] [ pageContent ] ]
            , div [ class "player" ] [ renderPlayer player ]
            , renderQueue queue player
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
                [ input [ class "form-control search-input", type_ "text", placeholder "Search" ] [] ]
            ]
        ]


renderQueue : Array Song -> Maybe PlayingInfo -> Html Msg
renderQueue queue playingInfo =
    div [ class "queue" ]
        [ h2 [ class "queue__title" ] [ text "Queue" ]
        , div [ class "queue__list" ] (Array.map renderQueueSong queue |> Array.toList)
        ]


renderQueueSong : Song -> Html Msg
renderQueueSong song =
    a [ class "queue__list__item pointer", onClick <| PlaySong song ]
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
    let
        playbuttonClass =
            case data of
                Just playingInfo ->
                    case playingInfo.state of
                        Paused ->
                            "fa-play"

                        _ ->
                            "fa-pause"

                Nothing ->
                    "fa-play"

        playAction =
            case data of
                Just playingInfo ->
                    case playingInfo.state of
                        Paused ->
                            Play

                        _ ->
                            Pause

                Nothing ->
                    Play
    in
        div [ class "player-bar row" ]
            [ div [ class "col-xs-12 hidden-lg-up song-info mobile-song-info" ]
                [ renderCurrentSongInfo data ]
            , div [ class "col-lg-6 player-controls" ]
                [ div [ class "row" ]
                    [ a [ class "col-xs-2 player-button previous-button", onClick Previous ]
                        [ i [ class "fa fa-fast-backward" ] [] ]
                    , a [ class "col-xs-2 player-button play-button", onClick playAction ]
                        [ i [ class <| "fa " ++ playbuttonClass ] [] ]
                    , a [ class "col-xs-2 player-button next-button", onClick Next ]
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
    let
        header =
            h3 [ class "collection__title" ] [ text "Latest Music" ]
    in
        div [ class "collection" ] (header :: List.map renderPlaylist playlists)


renderPlaylist : Playlist -> Html Msg
renderPlaylist playlist =
    div [ class "collection__item", onClick <| ChangePage (PlaylistPage playlist) ]
        [ img [ class "collection__item__image", src playlist.coverImageUrl ] []
        , div [ class "collection__item__content" ]
            [ h4 [ class "collection__item__title" ] [ text playlist.title ]
            ]
        ]


renderPlaylistSongs : Playlist -> Maybe PlayingInfo -> Html Msg
renderPlaylistSongs { title, songs, coverImageUrl } player =
    div [ class "playlist" ]
        [ div [ class "playlist__header" ]
            [ img [ src coverImageUrl ] []
            , div [ class "playlist__header__content" ]
                [ h3 [ class "playlist__header__content__title" ] [ text title ]
                , p [ class "playlist__header__content__info" ] [ text <| (toString (List.length songs)) ++ " tracks" ]
                ]
            ]
        , table [ class "table table-hover table-striped table-playlist" ]
            [ thead []
                [ tr []
                    [ th [] [ text "#" ]
                    , th [] [ text "Title" ]
                    , th [] [ text "Artist" ]
                    , th [] []
                    ]
                ]
            , tbody [] (List.indexedMap (renderSong player) songs)
            ]
        ]


renderSong : Maybe PlayingInfo -> Int -> Song -> Html Msg
renderSong player index song =
    let
        isCurrentSong =
            case player of
                Nothing ->
                    False

                Just playingInfo ->
                    song.id == playingInfo.song.id

        indexColumn =
            if isCurrentSong then
                td [ class "playing__icon pointer" ] [ icon "fa-play-circle-o" Pause ]
            else
                td [ class "song__item", onClick (PlaySong song) ] [ text (toString (index + 1)) ]
    in
        tr [ classList [ ( "current", isCurrentSong ) ] ]
            [ indexColumn
            , td [ onClick <| PlaySong song ]
                [ div [ class "song__info pointer" ]
                    [ img [ class "song__info__cover", src song.cover ] []
                    , div [ class "song__info__title" ] [ text song.title ]
                    ]
                ]
            , td [] [ text <| String.join ", " song.artists ]
            , td [ class "play__icon pointer" ] [ icon "fa-plus" (AddSongToQueue song) ]
            ]


icon : String -> Msg -> Html Msg
icon name msg =
    i [ classList [ ( "fa", True ), ( name, True ) ], onClick msg ] []
