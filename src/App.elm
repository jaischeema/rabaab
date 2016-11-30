port module App exposing (..)

import Http
import RemoteData exposing (..)
import Types exposing (..)
import Model exposing (..)
import Api exposing (playlistsRequest)


port setSource : DownloadLink -> Cmd msg


port setCurrentTime : Int -> Cmd msg


port setPlaybackRate : Int -> Cmd msg


port play : () -> Cmd msg


port pause : () -> Cmd msg


getPlaylists : Cmd Msg
getPlaylists =
    Http.send (PlaylistsResponse << RemoteData.fromResult) playlistsRequest


init : ( Model, Cmd Msg )
init =
    ( initModel, getPlaylists )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlaylistsResponse response ->
            ( { model | playlists = response }, Cmd.none )

        ChangePage page ->
            ( { model | currentPage = page }, Cmd.none )

        PlaySong song ->
            let
                playingInfo =
                    { song = song, duration = 0, elapsedTime = 0, state = Idle }

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
                    | currentPlaying = Just playingInfo
                    , queue = addSongToQueue song model.queue
                  }
                , command
                )

        AddSongToQueue song ->
            ( { model | queue = addSongToQueue song model.queue }, Cmd.none )

        RemoveSongFromQueue song ->
            ( { model | queue = List.filter (\x -> x.id /= song.id) model.queue }, Cmd.none )

        MoveSongInQueue _ _ ->
            ( model, Cmd.none )

        Pause ->
            case model.currentPlaying of
                Just playingInfo ->
                    ( { model | currentPlaying = Just { playingInfo | state = Paused } }, Cmd.none )

                Nothing ->
                    ( model, pause () )

        Play ->
            case model.currentPlaying of
                Just playingInfo ->
                    ( { model | currentPlaying = Just { playingInfo | state = Playing } }, Cmd.none )

                Nothing ->
                    ( model, play () )

        Next ->
            ( model, Cmd.none )

        Previous ->
            ( model, Cmd.none )

        SeekTo time ->
            ( model, Cmd.none )


addSongToQueue : Song -> List Song -> List Song
addSongToQueue song queue =
    let
        queueSong =
            queue |> List.filter (\x -> x.id == song.id) |> List.head
    in
        case queueSong of
            Nothing ->
                song :: queue

            Just _ ->
                queue
