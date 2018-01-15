module Api exposing (fetchCollection, fetchNotes)

import Json.Decode as Decode
import Json.Decode exposing (list, int, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Http
import Model exposing (..)
import Msg exposing (..)


fetchCollection : Cmd Msg
fetchCollection =
    let
        request =
            Http.get "/api/collection" decodeCollection
    in
        Http.send FetchedCollection request


fetchNotes : Cmd Msg
fetchNotes =
    let
        request =
            Http.get "/api/notes" decodeNotes
    in
        Http.send FetchedNotes request


decodeNotes : Decoder NotesRes
decodeNotes =
    decode NotesRes
        |> required "error" string
        |> required "payload" decodeNotesPayload


decodeNotesPayload : Decoder (List Note)
decodeNotesPayload =
    list
        (decode Note
            |> required "cid" (int)
            |> required "nid" (int)
            |> required "cmod" (int)
            |> required "nmod" (int)
            |> required "mid" (int)
            |> optional "tags" (string) ""
            |> required "one" (string)
            |> required "two" (string)
            |> required "did" (int)
            |> required "ord" (int)
            |> required "ttype" (int)
            |> required "queue" (int)
            |> required "due" (int)
            |> required "reps" (int)
            |> required "lapses" (int)
        )


decodeCollection : Decoder CollectionRes
decodeCollection =
    decode CollectionRes
        |> required "error" string
        |> required "payload" decodeCollectionPayload


decodeCollectionPayload : Decoder Collection
decodeCollectionPayload =
    decode Collection
        |> required "collection" decodeACollection
        |> required "decks" decodeADecks
        |> required "models" decodeAModels


decodeACollection : Json.Decode.Decoder ACollection
decodeACollection =
    decode ACollection
        |> required "crt" int
        |> required "mod" int
        |> required "tags" (list string)


decodeADecks : Decoder (List ADeck)
decodeADecks =
    list
        (decode ADeck
            |> required "did" int
            |> required "mod" int
            |> required "name" string
        )


decodeAModels : Decoder (List AModel)
decodeAModels =
    list
        (decode AModel
            |> required "did" int
            |> required "flds" (list string)
            |> required "mid" int
            |> required "mod" int
        )
