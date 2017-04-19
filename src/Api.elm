module Api exposing (..)

import Types exposing (..)
import Json.Decode exposing (int, string, list, andThen, nullable, decodeString, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Http


-- decodeSongType : String -> Decoder SongType
-- decodeSongType songType =
--     decodeString songType |> andThen songTypeDecoder


songTypeDecoder : String -> Result String SongType
songTypeDecoder songType =
    case songType of
        "song" ->
            Ok AlbumSong

        "single" ->
            Ok Single

        _ ->
            Err "Bad value for SongType"


songDecoder : Decoder Song
songDecoder =
    decode Song
        |> required "id" string
        |> required "title" string
        |> required "genre" (list string)
        |> required "type" string
        |> optional "released_on" (nullable string) Nothing
        |> required "artists" (list string)
        |> required "download_links" (list string)
        |> optional "category" (nullable string) Nothing
        |> optional "album_id" (nullable string) Nothing
        |> required "album_title" string
        |> required "cover" string
        |> hardcoded True


playlistDecoder : Decoder Playlist
playlistDecoder =
    decode Playlist
        |> required "id" int
        |> required "title" string
        |> required "songs" (list songDecoder)
        |> required "cover_image_url" string


playlistsDecoder : Decoder (List Playlist)
playlistsDecoder =
    list playlistDecoder


playlistsRequest : Http.Request (List Playlist)
playlistsRequest =
    Http.get "http://kaato.apnavirsa.net/api/v1/playlists" playlistsDecoder
