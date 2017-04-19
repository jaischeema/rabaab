port module App exposing (..)

import Http
import RemoteData exposing (..)
import Types exposing (..)
import Model exposing (..)
import Api exposing (playlistsRequest)
import Array exposing (..)


-- Ports to control the music player


port setSource : DownloadLink -> Cmd msg


port setCurrentTime : Int -> Cmd msg


port setPlaybackRate : Int -> Cmd msg


port play : () -> Cmd msg


port pause : () -> Cmd msg


port state : (String -> msg) -> Sub msg


port currentTime : (Float -> msg) -> Sub msg


port progress : (Float -> msg) -> Sub msg


port duration : (Float -> msg) -> Sub msg


port endItem : (String -> msg) -> Sub msg



-- Init


getPlaylists : Cmd Msg
getPlaylists =
    Http.send (PlaylistsResponse << RemoteData.fromResult) playlistsRequest


init : ( Model, Cmd Msg )
init =
    ( initModel, getPlaylists )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ state ChangePlayerState
        , currentTime ChangePlayerCurrentTime
        , progress ChangePlayerDownloadedProgress
        , duration ChangePlayerDuration
        , endItem ItemEnded
        ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlaylistsResponse response ->
            ( { model | playlists = response }, Cmd.none )

        ChangePage page ->
            ( { model | currentPage = page }, Cmd.none )

        PlaySong song ->
            playSong song model

        AddSongToQueue song ->
            ( { model | queue = addSongToQueue song model.queue }, Cmd.none )

        RemoveSongFromQueue song ->
            ( { model | queue = Array.filter (\x -> x.id /= song.id) model.queue }, Cmd.none )

        MoveSongInQueue _ _ ->
            ( model, Cmd.none )

        Pause ->
            ( model, pause () )

        Play ->
            ( model, play () )

        ItemEnded _ ->
            playNextSong model

        Next ->
            playNextSong model

        Previous ->
            ( model, Cmd.none )

        SeekTo time ->
            ( model, Cmd.none )

        ChangePlayerState stateString ->
            let
                playerState =
                    case stateString of
                        "playing" ->
                            Playing

                        "paused" ->
                            Paused

                        "loading" ->
                            Buffering

                        _ ->
                            Idle

                player =
                    Maybe.map (\playingInfo -> { playingInfo | state = playerState }) model.player
            in
                ( { model | player = player }, Cmd.none )

        ChangePlayerCurrentTime currentTime ->
            let
                player =
                    Maybe.map (\playingInfo -> { playingInfo | currentTime = currentTime }) model.player
            in
                ( { model | player = player }, Cmd.none )

        ChangePlayerDuration duration ->
            let
                player =
                    Maybe.map (\playingInfo -> { playingInfo | duration = duration }) model.player
            in
                ( { model | player = player }, Cmd.none )

        ChangePlayerDownloadedProgress downloadProgress ->
            let
                player =
                    Maybe.map (\playingInfo -> { playingInfo | downloadProgress = downloadProgress }) model.player
            in
                ( { model | player = player }, Cmd.none )


playSong : Song -> Model -> ( Model, Cmd Msg )
playSong song model =
    let
        playingInfo =
            { song = song, duration = 0, currentTime = 0, downloadProgress = 0, state = Idle }

        source =
            List.head song.downloadLinks

        command =
            case source of
                Nothing ->
                    Cmd.none

                Just link ->
                    setSource link
    in
        ( { model
            | player = Just playingInfo
            , queue = addSongToQueue song model.queue
          }
        , command
        )


playNextSong : Model -> ( Model, Cmd Msg )
playNextSong model =
    case nextSongInQueue (Maybe.map .song model.player) model.queue of
        Nothing ->
            ( model, Cmd.none )

        Just song ->
            playSong song model


addSongToQueue : Song -> Array Song -> Array Song
addSongToQueue song queue =
    let
        queueSong =
            queue |> Array.filter (\x -> x.id == song.id) |> Array.get 0
    in
        case queueSong of
            Nothing ->
                Array.push song queue

            Just _ ->
                queue


nextSongInQueue : Maybe Song -> Array Song -> Maybe Song
nextSongInQueue currentSong queue =
    case currentSong of
        Nothing ->
            Array.get 0 queue

        Just song ->
            let
                indexFunction index item =
                    if song.id == item.id then
                        Just index
                    else
                        Nothing

                filterFunction item =
                    case item of
                        Nothing ->
                            False

                        _ ->
                            True

                currentSongIndex =
                    Array.indexedMap indexFunction queue
                        |> Array.filter filterFunction
                        |> Array.get 0
                        |> Maybe.withDefault (Just 0)
                        |> Maybe.withDefault 0
            in
                Array.get (currentSongIndex + 1) queue
